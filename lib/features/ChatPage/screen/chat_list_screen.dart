import 'package:dabbawala/features/ChatPage/model/group.dart';
import 'package:flutter/material.dart';
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
      // final user = Supabase.instance.client.auth.currentUser;

      // if (user == null) {
      //   setState(() {
      //     error = "User is not logged in.";
      //     isLoading = false;
      //   });
      //   return; // ✅ Exit the function if user is not authenticated
      // }
      String userId = GetStorage().read('user_id');
      
      final response = await Supabase.instance.client
          .from('groups')
          .select('''
          *,
          group_members!inner(is_admin)
        ''')
          .eq('group_members.user_id', userId) // ✅ Safe access to `id`
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return ListTile(
            title: Text(group.name),
            subtitle: group.messagingDisabled
                ? const Text('Messaging disabled',
                    style: TextStyle(color: Colors.red))
                : null,
            leading: CircleAvatar(child: Text(group.name[0])),
            trailing:
                group.isAdmin ? const Icon(Icons.admin_panel_settings) : null,
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
          );
        },
      ),
    );
  }
}
