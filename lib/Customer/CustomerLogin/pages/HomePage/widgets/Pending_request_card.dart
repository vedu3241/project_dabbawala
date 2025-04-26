import 'package:dabbawala/Customer/CustomerLogin/pages/Payment/pages/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingRequestCard extends StatelessWidget {
  final dynamic request; // Using dynamic for flexibility
  
  const PendingRequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    // Status badges
    final Map<String, Color> statusColors = {
      'Pending': Colors.orange,
      'Accepted': Colors.green,
      'Rejected': Colors.red,
    };
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Dabbawala and status section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 30,
                  backgroundImage: request.dabbawalaDetails?.profilePicUrl != null && 
                                  request.dabbawalaDetails.profilePicUrl.isNotEmpty
                      ? NetworkImage(request.dabbawalaDetails.profilePicUrl)
                      : const AssetImage('assets/images/placeholder.jpg') as ImageProvider,
                ),
                const SizedBox(width: 16),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.dabbawalaDetails?.name ?? 'Dabbawala',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${request.schedule} Plan',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Request Date: ${request.requestDate}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColors[request.status]?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: statusColors[request.status] ?? Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    request.status ?? 'Unknown',
                    style: TextStyle(
                      color: statusColors[request.status] ?? Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: Color(0xFFEDF2F7)),
          
          // Payment section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pricing info based on subscription
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Fee',
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPriceForPlan(request.schedule),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
                
                // Pay button - enabled only if request is accepted
                ElevatedButton(
                  onPressed: request.status == 'Accepted' 
                    ? () {
                        // Navigate to payment screen
                        Get.to(() => PaymentScreen(requestId: request.requestId));
                      }
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38A169),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    request.status == 'Accepted' ? 'Pay Now' : 'Awaiting Response',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to get pricing based on subscription plan
  String _getPriceForPlan(String? plan) {
    switch (plan) {
      case 'Weekly':
        return '₹350';
      case 'Monthly':
        return '₹1,200';
      case 'Yearly':
        return '₹12,000';
      default:
        return '₹0';
    }
  }
}