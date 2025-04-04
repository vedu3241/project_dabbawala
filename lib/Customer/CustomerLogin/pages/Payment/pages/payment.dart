import 'package:dabbawala/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentScreen extends StatefulWidget {
  final Function(String plan, double amount) onPaymentSuccess;

  const PaymentScreen({super.key, required this.onPaymentSuccess});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPlan = 'Weekly';
  double selectedAmount = 500; // Default amount for Weekly plan

  void updateAmount(String plan) {
    switch (plan) {
      case 'Weekly':
        selectedAmount = 500;
        break;
      case 'Monthly':
        selectedAmount = 1800;
        break;
      case 'Yearly':
        selectedAmount = 20000;
        break;
    }
    setState(() {
      selectedPlan = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Options',
          style: GoogleFonts.ubuntu(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildPlanOption('Weekly', 500),
            buildPlanOption('Monthly', 1800),
            buildPlanOption('Yearly', 20000),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              onPressed: () {
                widget.onPaymentSuccess(selectedPlan, selectedAmount);
                Get.back(); // Navigate back to the previous screen
                // THelperFunctions.showSnackBar('Dabbawala Hired Successfully');
              },
              child: Text(
                "Pay ₹${selectedAmount.toStringAsFixed(2)}",
                style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlanOption(String planName, double amount) {
    return ListTile(
      title: Text(planName, style: GoogleFonts.ubuntu(fontSize: 18)),
      subtitle: Text("₹${amount.toStringAsFixed(2)}"),
      leading: Radio<String>(
        value: planName,
        groupValue: selectedPlan,
        onChanged: (value) {
          if (value != null) {
            updateAmount(value);
          }
        },
        activeColor: Colors.deepPurple,
      ),
    );
  }
}
