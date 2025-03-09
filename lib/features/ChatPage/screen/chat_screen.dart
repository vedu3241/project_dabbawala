import 'package:flutter/material.dart';
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
      event: PostgresChangeEvent.insert, // ✅ Correct event type
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'group_id',
          value: 200), // ✅ Correct filter syntax
      callback: (payload) async {
        final message = payload.newRecord as Map<String, dynamic>?;
        if (message == null) return; // ✅ Prevents null errors

        try {
          // Fetch user details for the new message
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

            // ✅ Ensure safe scrolling
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
          debugPrint('Error processing new message: $e'); // ✅ Logs any errors
        }
      },
    );

    _realtimeChannel?.subscribe(); // ✅ Subscribe to the channel
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

      if (response != null && response is List<dynamic>) {
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

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Card(
          color: isMe ? Theme.of(context).primaryColor : Colors.grey[100],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: message.userProfilePicUrl.isNotEmpty
                            ? NetworkImage(message.userProfilePicUrl)
                            : null,
                        child: message.userProfilePicUrl.isEmpty
                            ? Text(message.userName.isNotEmpty
                                ? message.userName[0]
                                : '?')
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        message.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 4),
                Text(
                  message.content,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeago.format(message.createdAt),
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: _messages.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _messages.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final message = _messages[index];
                          final isMe = message.userId == currentUserId;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildMessageBubble(message, isMe),
                          );
                        },
                      ),
                      if (_isLoadingMore)
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(),
                        ),
                    ],
                  ),
          ),
          if (!widget.messagingDisabled)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.grey[200]
                                : Colors.grey[800],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  MaterialButton(
                    onPressed: _sendMessage,
                    shape: const CircleBorder(),
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (widget.messagingDisabled) return;

    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();

    try {
      await Supabase.instance.client.from('messages').insert({
        'group_id': widget.groupId,
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'content': content,
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            backgroundColor: Colors.red,
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
