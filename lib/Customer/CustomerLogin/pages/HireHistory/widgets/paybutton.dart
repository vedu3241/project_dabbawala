import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Hire/model/hire_dabbawala_model.dart';
import '../controller/hire_history_controller.dart';

class PaymentButton extends StatelessWidget {
  final HireRequest hireRequest;
  
  const PaymentButton({super.key, required this.hireRequest});

  @override
  Widget build(BuildContext context) {
    final HireHistoryController controller = Get.find<HireHistoryController>();
    
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          // Show payment confirmation dialog
          Get.defaultDialog(
            title: "Confirm Payment",
            content: Column(
              children: [
                Text("Plan: ${hireRequest.schedule}"),
                const SizedBox(height: 8),
                Text(
                  "Amount: ₹${_getPlanAmount(hireRequest.schedule)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            textConfirm: "Pay Now",
            textCancel: "Cancel",
            confirmTextColor: Colors.white,
            onConfirm: () {
              // Update status to completed
              controller.updateHireRequestStatus(hireRequest.requestId, "Completed");
              Get.back(); // Close dialog
              
              // Show success message
              Get.snackbar(
                "Payment Successful", 
                "You have hired ${hireRequest.dabbawalaDetails.name} successfully!",
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            },
          );
        },
        icon: const Icon(Icons.payment),
        label: const Text("Make Payment"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
  
  // Helper to get plan amount
  String _getPlanAmount(String plan) {
    switch (plan) {
      case "Weekly":
        return "500";
      case "Monthly":
        return "1800";
      case "Yearly":
        return "20000";
      default:
        return "1800";
    }
  }
}