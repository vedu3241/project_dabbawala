import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/widgets/Pending_request_card.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Navigation/pages/custnavbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../HireHistory/controller/hire_history_controller.dart';

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  State<PendingRequestsScreen> createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    // Ensure HireHistoryController is available
    final HireHistoryController controller = Get.put(HireHistoryController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(AnimatedNavBar());
          },
        ),
        title: Text(
          'yourrequest'.tr,  // Changed from 'pending_request' to something more general
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 244, 245, 247),
        foregroundColor: const Color.fromARGB(255, 15, 15, 15),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              // Update the status of pending requests
              controller.updatePendingRequestsStatus();
            },
          ),
        ],
      ),
      body: GetBuilder<HireHistoryController>(
        builder: (historyController) {
          // Include both Pending and recently Accepted/Hired requests
          final filteredRequests = historyController.hireHistoryList
              .where((request) => 
                  request.status == 'Pending' || 
                  request.status == 'Accepted' || 
                  request.status == 'Hired')
              .toList();

          if (filteredRequests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    size: 80,
                    color: Color(0xFFAAABAA),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'no_requests'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'hire_request_appear'.tr,
                    style: TextStyle(
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredRequests.length,
            itemBuilder: (context, index) {
              final request = filteredRequests[index];
              return PendingRequestCard(
                request: request, 
                key: Key(request.requestId), // Using request ID as a unique key
              );
            },
          );
        },
      ),
    );
  }
}