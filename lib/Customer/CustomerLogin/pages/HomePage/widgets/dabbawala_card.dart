// // Updated: dabbawala_card.dart with persistent HireController state
// import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/widgets/customer_hireform.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../Hire/controller/hire_controller.dart';
// import '../model/dabbawala_model.dart';
// import '../../HireHistory/controller/hire_history_controller.dart';
// import 'Pending_request.dart';

// class DabbawalaCard extends StatelessWidget {
//   final String dabbawalaId;
//   final String customerId;
//   final Dabbawala dabbawala;

//   const DabbawalaCard({
//     super.key,
//     required this.dabbawala,
//     required this.dabbawalaId,
//     required this.customerId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Get existing HireController instead of creating a new one
//     Get.put<HireController>(HireController(), permanent: true);

//     // Ensure HireHistoryController is available
//     if (!Get.isRegistered<HireHistoryController>()) {
//       Get.put(HireHistoryController());
//     }

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Material(
//           color: Colors.transparent,
//           child: Column(
//             children: [
//               // Header with profile image and key info
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Profile Image with better styling
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.grey.shade300, width: 2),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 8,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         radius: 35,
//                         backgroundColor: Colors.grey.shade200,
//                         backgroundImage: dabbawala.profilePicUrl != null && dabbawala.profilePicUrl!.isNotEmpty
//                             ? NetworkImage(dabbawala.profilePicUrl!)
//                             : const AssetImage('assets/images/profilepic.png') as ImageProvider,
//                       ),
//                     ),
//                     const SizedBox(width: 16),

//                     // Info with improved typography
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             dabbawala.name,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                               letterSpacing: 0.2,
//                               color: Color(0xFF2D3748),
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           const SizedBox(height: 4),
//                           _buildInfoRow(Icons.home, dabbawala.address),
//                           const SizedBox(height: 4),
//                           _buildInfoRow(Icons.location_city, dabbawala.city),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const Divider(height: 1, thickness: 1, color: Color(0xFFEDF2F7)),

//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: GetBuilder<HireController>(
//                   builder: (ctrl) {
//                     // Check if THIS specific dabbawalaId is in the requested list
//                     bool isRequested = ctrl.currentCustomerInfo.containsKey(dabbawalaId);

//                     return SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: isRequested
//                             ? () {
//                                 Get.to(() => const PendingRequestsScreen());
//                               }
//                             : () {
//                                 Get.to(() => CustomerFormScreen(
//                                       dabbawala: dabbawala,
//                                       dabbawalaId: dabbawalaId,
//                                       customerId: customerId,
//                                     ));
//                               },
//                         icon: Icon(
//                           isRequested ? Icons.history : Icons.handshake,
//                           size: 20,
//                         ),
//                         label: Text(
//                           isRequested ? "View Request" : "Hire Dabbawala",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               isRequested ? Colors.orange.shade600 : const Color.fromARGB(255, 132, 5, 218),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           elevation: 2,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: Colors.grey.shade600),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade800,
//               height: 1.4,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/widgets/customer_hireform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Hire/controller/hire_controller.dart';
import '../model/dabbawala_model.dart';
import '../../HireHistory/controller/hire_history_controller.dart';
import 'Pending_request.dart';

class DabbawalaCard extends StatelessWidget {
  final String dabbawalaId;
  final String customerId;
  final Dabbawala dabbawala;

  const DabbawalaCard({
    super.key,
    required this.dabbawala,
    required this.dabbawalaId,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    // Get existing HireController instead of creating a new one
    final HireController hireController = Get.put<HireController>(HireController(), permanent: true);

    // Ensure HireHistoryController is available
    if (!Get.isRegistered<HireHistoryController>()) {
      Get.put(HireHistoryController());
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
      decoration: BoxDecoration(
        // color: Color(0xFFff1faee),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              // Header with profile image and key info
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image with better styling
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: dabbawala.profilePicUrl != null && dabbawala.profilePicUrl!.isNotEmpty
                            ? NetworkImage(dabbawala.profilePicUrl!)
                            : const AssetImage('assets/images/profilepic.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Info with improved typography
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dabbawala.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 6),
                            _buildInfoRow(Icons.phone, dabbawala.mobile_no),
                          const SizedBox(height: 4),
                          _buildInfoRow(Icons.home, dabbawala.address),
                          const SizedBox(height: 4),
                          _buildInfoRow(Icons.location_city, dabbawala.city),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFEDF2F7)),
            SizedBox(height: 15,),
              // Hired Tag and Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: GetBuilder<HireController>(
                  builder: (ctrl) {
                    // Check if the specific dabbawalaId is in the hired list
                    bool isHired = ctrl.hiredDabbawalas.contains(dabbawalaId);

                    return Column(
                      children: [
                        if (isHired) 
                          // Display "Hired" tag at the top-right corner
                          Positioned(
                            right: 16,
                            top: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              color: Colors.green,
                              child: const Text(
                                "Hired",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: isHired
                                ? () {
                                    Get.to(() => const PendingRequestsScreen());
                                  }
                                : () {
                                    Get.to(() => CustomerFormScreen(
                                          dabbawala: dabbawala,
                                          dabbawalaId: dabbawalaId,
                                          customerId: customerId,
                                        ));
                                  },
                            icon: Icon(
                              isHired ? Icons.history : Icons.handshake_outlined,
                              size: 20,
                            ),
                            label: Text(
                              isHired ? "View Request" : "hire_dabbawala".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: 
                                  isHired ? Colors.orange.shade600 : const Color(0xFF507dbc),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
