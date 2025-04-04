import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:timeago/timeago.dart' as timeago;

class ChatMessage {
  final String id;
  final String content;
  final String userId;
  final DateTime createdAt;
  final String userName;
  final String userProfilePicUrl;

  ChatMessage({
    required this.id,
    required this.content,
    required this.userId,
    required this.createdAt,
    required this.userName,
    required this.userProfilePicUrl,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final user = map['users'] as Map<String, dynamic>?;
    return ChatMessage(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      userId: map['user_id'] ?? '',
      createdAt:
          DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      userName: user?['name'] ?? 'Unknown User',
      userProfilePicUrl: user?['profile_pic_url'] ?? '',
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String groupId;
  final bool messagingDisabled;

  const ChatScreen({
    required this.groupId,
    required this.messagingDisabled,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  RealtimeChannel? _realtimeChannel;

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  static const int _limit = 20;

  // WhatsApp colors
  final Color _whatsAppGreen = const Color(0xff780000);
  final Color _whatsAppLightGreen = const Color(0xFF25D366);
  final Color _whatsAppBackground = const Color(0xFFECE5DD);
  final Color _whatsAppDarkBackground = const Color(0xFF262D31);
  final Color _outgoingMessageColor = const Color(0xFFDCF8C6);
  final Color _incomingMessageColor = const Color(0xFFFFFFFF);
  final Color _outgoingMessageDarkColor = const Color(0xFF056162);
  final Color _incomingMessageDarkColor = const Color(0xFF2A2C31);

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.hasClients &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        if (!_isLoadingMore && _hasMore) {
          _loadMoreMessages();
        }
      }
    });
  }

  Future<void> _initializeChat() async {
    await _loadMessages(initial: true);
    _setupRealtimeSubscription();
  }

  void _setupRealtimeSubscription() {
    _realtimeChannel = Supabase.instance.client.channel(
        'chat_${widget.groupId}',
        opts: const RealtimeChannelConfig(self: true));

    _realtimeChannel?.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'group_id',
          value: widget.groupId),
      callback: (payload) async {
        final message = payload.newRecord as Map<String, dynamic>?;
        if (message == null) return;

        try {
          final userResponse = await Supabase.instance.client
              .from('users')
              .select()
              .eq('id', message['user_id'])
              .single();

          final newMessage = ChatMessage.fromMap({
            ...message,
            'users': userResponse,
          });

          if (mounted && !_messages.any((msg) => msg.id == newMessage.id)) {
            setState(() {
              _messages.insert(0, newMessage);
            });

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients &&
                  _scrollController.position.pixels <=
                      _scrollController.position.minScrollExtent + 50) {
                _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        } catch (e) {
          debugPrint('Error processing new message: $e');
        }
      },
    );

    _realtimeChannel?.subscribe(
      (status, error) {
        if (status == RealtimeSubscribeStatus.subscribed) {
          debugPrint('Successfully subscribed to chat channel');
        } else if (error != null) {
          debugPrint('Error subscribing to chat channel: $error');
        }
      },
    );
  }

  Future<void> _loadMessages({bool initial = false}) async {
    if (initial) {
      setState(() => _isLoading = true);
    } else {
      setState(() => _isLoadingMore = true);
    }

    try {
      final response = await Supabase.instance.client
          .from('messages')
          .select('''
          id, content, user_id, created_at,
          users:user_id (name, profile_pic_url)
        ''')
          .eq('group_id', widget.groupId)
          .order('created_at', ascending: false)
          .range(_offset, _offset + _limit - 1);

      if (response is List<dynamic>) {
        final newMessages =
            response.map((msg) => ChatMessage.fromMap(msg)).toList();

        if (mounted) {
          setState(() {
            if (initial) {
              _messages.clear();
            }
            _messages.addAll(newMessages);
            _hasMore = newMessages.length == _limit;
            _offset += newMessages.length;
            _isLoading = false;
            _isLoadingMore = false;
          });
        }
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _loadMoreMessages() async {
    await _loadMessages();
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == DateTime(now.year, now.month, now.day)) {
      return 'TODAY';
    } else if (messageDate == yesterday) {
      return 'YESTERDAY';
    } else {
      // Format like "12 MARCH 2025"
      final months = [
        'JANUARY',
        'FEBRUARY',
        'MARCH',
        'APRIL',
        'MAY',
        'JUNE',
        'JULY',
        'AUGUST',
        'SEPTEMBER',
        'OCTOBER',
        'NOVEMBER',
        'DECEMBER'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  Widget _buildWhatsAppMessageBubble(ChatMessage message, bool isMe) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor = isMe
        ? (isDarkMode ? _outgoingMessageDarkColor : _outgoingMessageColor)
        : (isDarkMode ? _incomingMessageDarkColor : _incomingMessageColor);
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
          margin: EdgeInsets.only(
            left: isMe ? 60 : 10,
            right: isMe ? 10 : 60,
            top: 5,
            bottom: 5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
              bottomLeft: isMe ? const Radius.circular(10) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(10),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          message.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: _whatsAppGreen,
                          ),
                        ),
                      ),
                    Text(
                      message.content,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 4,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 3),
                    if (isMe)
                      Icon(
                        Icons.check,
                        size: 14,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _formatDateHeader(date),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? _whatsAppLightGreen : _whatsAppGreen;
    final backgroundColor =
        isDarkMode ? _whatsAppDarkBackground : _whatsAppBackground;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.group,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Group Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Text(
                  //   'Tap here for group info',
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     color: Colors.white.withOpacity(0.8),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage(isDarkMode
          //       ? 'assets/whatsapp_dark_bg.png' // You would need to add these assets
          //       : 'assets/whatsapp_bg.png'),
          //   repeat: ImageRepeat.repeat,
          //   opacity: 0.5,
          // ),
          color: backgroundColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : Stack(
                      children: [
                        _messages.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      size: 48,
                                      color: primaryColor.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No messages yet',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Be the first to send a message!',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.grey[500]
                                            : Colors.grey[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                reverse: true,
                                controller: _scrollController,
                                padding: const EdgeInsets.all(8),
                                itemCount:
                                    _messages.length + (_hasMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == _messages.length) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  final message = _messages[index];
                                  final isMe = message.userId == currentUserId;

                                  // Check if we need a date header
                                  final bool showDateHeader =
                                      index == _messages.length - 1 ||
                                          !_isSameDay(message.createdAt,
                                              _messages[index + 1].createdAt);

                                  return Column(
                                    children: [
                                      if (showDateHeader)
                                        _buildDateHeader(message.createdAt),
                                      _buildWhatsAppMessageBubble(
                                          message, isMe),
                                    ],
                                  );
                                },
                              ),
                        if (_isLoadingMore)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(
                              minHeight: 2,
                              backgroundColor: primaryColor.withOpacity(0.2),
                              color: primaryColor,
                            ),
                          ),
                      ],
                    ),
            ),
            if (!widget.messagingDisabled)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            // IconButton(
                            //   icon: Icon(
                            //     Icons.emoji_emotions_outlined,
                            //     color: isDarkMode
                            //         ? Colors.grey[400]
                            //         : Colors.grey[600],
                            //   ),
                            //   onPressed: () {
                            //     // Emoji action
                            //   },
                            // ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Type a message',
                                  hintStyle: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 0,
                                  ),
                                ),
                              ),
                            ),
                            // IconButton(
                            //   icon: Icon(
                            //     Icons.attach_file,
                            //     color: isDarkMode
                            //         ? Colors.grey[400]
                            //         : Colors.grey[600],
                            //   ),
                            //   onPressed: () {
                            //     // Attachment action
                            //   },
                            // ),
                            // IconButton(
                            //   icon: Icon(
                            //     Icons.camera_alt,
                            //     color: isDarkMode
                            //         ? Colors.grey[400]
                            //         : Colors.grey[600],
                            //   ),
                            //   onPressed: () {
                            //     // Camera action
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _messageController.text.trim().isEmpty
                              ? Icons.send
                              : Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _sendMessage() async {
    if (widget.messagingDisabled) return;

    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();

    try {
      String userId = GetStorage().read('user_id');
      await Supabase.instance.client.from('messages').insert({
        'group_id': widget.groupId,
        'user_id': userId,
        'content': content,
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'RETRY',
              textColor: Colors.white,
              onPressed: _sendMessage,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
