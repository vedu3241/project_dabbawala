// import 'package:dabbawala/features/HireRequest/controller/dabbawala_request_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';

// class DabbawalaRequestScreen extends StatelessWidget {
//   final DabbawalaRequestController controller =
//       Get.put(DabbawalaRequestController());

//   DabbawalaRequestScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Incoming Hire Requests"),
//         backgroundColor: const Color(0xFF38A169),
//         foregroundColor: Colors.white,
//       ),
//       body: Obx(() {
//         if (controller.pendingRequests.isEmpty) {
//           return const Center(child: Text("No new requests."));
//         }
//         return ListView.builder(
//           itemCount: controller.pendingRequests.length,
//           itemBuilder: (context, index) {
//             final request = controller.pendingRequests[index];
//             return Card(
//               margin: const EdgeInsets.all(12),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Customer: ${request.customerId}",
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     Text(
//                         "Address: ${request.customerDetails['address'] ?? 'N/A'}"),
//                     Text(
//                         "Phone: ${request.customerDetails['mobileNo'] ?? 'N/A'}"),
//                     Text("Plan: ${request.schedule}"),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: () => controller.updateStatus(
//                               request.requestId, "Accepted"),
//                           icon: const Icon(Icons.check),
//                           label: const Text("Accept"),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green),
//                         ),
//                         const SizedBox(width: 10),
//                         ElevatedButton.icon(
//                           onPressed: () => controller.updateStatus(
//                               request.requestId, "Rejected",
//                               reason: "Not available"),
//                           icon: const Icon(Icons.close),
//                           label: const Text("Reject"),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
