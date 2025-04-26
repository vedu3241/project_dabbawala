// import 'package:dabbawala/features/ChatPage/model/group.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'chat_screen.dart';

// class ChatListScreen extends StatefulWidget {
//   const ChatListScreen({super.key});

//   @override
//   State<ChatListScreen> createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   List<Group> groups = [];
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     loadGroups();
//   }

//   Future<void> loadGroups() async {
//     try {
//       // final user = Supabase.instance.client.auth.currentUser;

//       // if (user == null) {
//       //   setState(() {
//       //     error = "User is not logged in.";
//       //     isLoading = false;
//       //   });
//       //   return; // ✅ Exit the function if user is not authenticated
//       // }
//       String userId = GetStorage().read('user_id');

//       final response = await Supabase.instance.client
//           .from('groups')
//           .select('''
//           *,
//           group_members!inner(is_admin)
//         ''')
//           .eq('group_members.user_id', userId) // ✅ Safe access to `id`
//           .order('created_at', ascending: false);

//       setState(() {
//         groups = (response as List<dynamic>).map((group) {
//           final isAdmin =
//               (group['group_members'] as List).first['is_admin'] as bool;
//           return Group.fromMap({...group, 'is_admin': isAdmin});
//         }).toList();
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (error != null) {
//       return Scaffold(
//         body: Center(child: Text('Error: $error')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Chats'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await Supabase.instance.client.auth.signOut();
//               if (mounted) {
//                 Navigator.of(context).pushReplacementNamed('/login');
//               }
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: groups.length,
//         itemBuilder: (context, index) {
//           final group = groups[index];
//           return ListTile(
//             title: Text(group.name),
//             subtitle: group.messagingDisabled
//                 ? const Text('Messaging disabled',
//                     style: TextStyle(color: Colors.red))
//                 : null,
//             leading: CircleAvatar(child: Text(group.name[0])),
//             trailing:
//                 group.isAdmin ? const Icon(Icons.admin_panel_settings) : null,
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ChatScreen(
//                     groupId: group.id,
//                     messagingDisabled: group.messagingDisabled,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:dabbawala/features/ChatPage/model/group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Group> groups = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  Future<void> loadGroups() async {
    try {
      String userId = GetStorage().read('user_id');

      final response = await Supabase.instance.client
          .from('groups')
          .select('''
          *,
          group_members!inner(is_admin)
        ''')
          .eq('group_members.user_id', userId)
          .order('created_at', ascending: false);

      setState(() {
        groups = (response as List<dynamic>).map((group) {
          final isAdmin =
              (group['group_members'] as List).first['is_admin'] as bool;
          return Group.fromMap({...group, 'is_admin': isAdmin});
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading your chats...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    error = null;
                  });
                  loadGroups();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:  Text('my_chats'.tr),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body:
          groups.isEmpty ? _buildEmptyState(context) : _buildChatList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create new group page
          // This is a placeholder for future functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Create new chat group (placeholder)')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No chat groups yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Your chat groups will appear here',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Create a new group'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Create new chat group (placeholder)')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadGroups,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: groups.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 70),
        itemBuilder: (context, index) {
          final group = groups[index];
          return _buildChatTile(context, group);
        },
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, Group group) {
    // Generate a color based on the group name for the avatar
    final color = Colors.primaries[group.name.length % Colors.primaries.length];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  groupId: group.id,
                  messagingDisabled: group.messagingDisabled,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 24,
                  child: Text(
                    group.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              group.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (group.isAdmin)
                            Tooltip(
                              message: 'You are an admin',
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Admin',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (group.messagingDisabled)
                        Row(
                          children: [
                            Icon(
                              Icons.block,
                              size: 14,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Messaging disabled',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      else
                        const Text(
                          'Tap to open chat',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
