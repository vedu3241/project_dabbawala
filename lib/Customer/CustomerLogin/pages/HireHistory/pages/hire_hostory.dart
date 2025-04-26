import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HireHistoryScreen extends StatefulWidget {
  const HireHistoryScreen({super.key});

  @override
  State<HireHistoryScreen> createState() => _HireHistoryScreenState();
}

class _HireHistoryScreenState extends State<HireHistoryScreen> {
  final String customerId = FirebaseAuth.instance.currentUser!.uid;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hire History'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Use a stream for real-time updates
        stream: FirebaseFirestore.instance
            .collection('hire_history')
            .where('customerId', isEqualTo: customerId)
            .orderBy('requestDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hire history found'));
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              // Format date
              final Timestamp timestamp = data['requestDate'] as Timestamp;
              final DateTime date = timestamp.toDate();
              final String formattedDate = DateFormat('MMM d, yyyy').format(date);
              
              // Get dabbawala details
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('dabbawalas')
                    .doc(data['dabbawalaId'])
                    .get(),
                builder: (context, dabbawalaSnapshot) {
                  if (dabbawalaSnapshot.connectionState == ConnectionState.waiting) {
                    return const Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text('Loading...'),
                      ),
                    );
                  }
                  
                  String dabbawalaName = 'Unknown Dabbawala';
                  String dabbawalaImage = '';
                  
                  if (dabbawalaSnapshot.hasData && dabbawalaSnapshot.data!.exists) {
                    final dabbawalaData = dabbawalaSnapshot.data!.data() as Map<String, dynamic>;
                    dabbawalaName = dabbawalaData['name'] ?? 'Unknown Dabbawala';
                    dabbawalaImage = dabbawalaData['profileImage'] ?? '';
                  }
                  
                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: dabbawalaImage.isNotEmpty
                                    ? NetworkImage(dabbawalaImage)
                                    : null,
                                child: dabbawalaImage.isEmpty
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dabbawalaName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Plan: ${data['subscriptionType'] ?? 'Unknown'}'),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(data['status']),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  data['status'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Request Date: $formattedDate'),
                              data['status'] == 'pending'
                                  ? TextButton(
                                      onPressed: () {
                                        _cancelHireRequest(doc.id);
                                      },
                                      child: const Text('Cancel'),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
  
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
  
  void _cancelHireRequest(String requestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request'),
        content: const Text('Are you sure you want to cancel this hire request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Update hire_history collection
              FirebaseFirestore.instance
                  .collection('hire_history')
                  .doc(requestId)
                  .update({
                'status': 'cancelled',
                'lastUpdated': DateTime.now(),
              });
              
              // Update hire_requests collection
              FirebaseFirestore.instance
                  .collection('hire_requests')
                  .doc(requestId)
                  .update({
                'status': 'cancelled',
                'lastUpdated': DateTime.now(),
              });
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}