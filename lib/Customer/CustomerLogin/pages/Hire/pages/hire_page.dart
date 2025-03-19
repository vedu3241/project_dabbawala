import 'package:dabbawala/Customer/CustomerLogin/pages/Payment/pages/payment.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/SignUp/screen/csignup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/controller/hire_controller.dart';

class CustomerFormScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final HireController hireController = Get.put(HireController());

  CustomerFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dabbawalaData = Get.arguments as Map<String, dynamic>? ?? {};

    if (dabbawalaData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Error"),backgroundColor: Colors.white),
        body: Center(child: Text("Dabbawala data not found!")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Hire Dabbawala", style: GoogleFonts.ubuntu(fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDabbawalaInfo(dabbawalaData),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: buildDropdownField()),
                    SizedBox(width: 10),
                    Expanded(child: buildDatePicker(context)),
                  ],
                ),
                SizedBox(height: 20),
                buildSecureCheckbox(),
                SizedBox(height: 350),
                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDabbawalaInfo(Map<String, dynamic> dabbawalaData) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(3, 3)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              dabbawalaData['imagePath'] ?? '',
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 80, color: Colors.red);
              },
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dabbawalaData['name'] ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  dabbawalaData['area'] ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 5),
                RatingBarIndicator(
                  rating: dabbawalaData['rating']?.toDouble() ?? 0.0,
                  itemBuilder: (context, index) =>
                      Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField() {
    return Obx(() => DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Schedule",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          value: hireController.selectedSchedule.value.isEmpty
              ? null
              : hireController.selectedSchedule.value,
          items: ["Yearly", "Monthly", "Weekly"].map((String schedule) {
            return DropdownMenuItem<String>(
              value: schedule,
              child: Text(schedule),
            );
          }).toList(),
          onChanged: (value) => hireController.selectedSchedule.value = value!,
        ));
  }

  Widget buildDatePicker(BuildContext context) {
    return Obx(() => TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Valid Till",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              hireController.selectedDate.value = picked;
            }
          },
          controller: TextEditingController(
            text: hireController.selectedDate.value == null
                ? ""
                : DateFormat('MM/yyyy')
                    .format(hireController.selectedDate.value!),
          ),
        ));
  }

  Widget buildSecureCheckbox() {
    return Obx(() => Row(
          children: [
            Checkbox(
              value: hireController.isSecure.value,
              onChanged: (bool? value) =>
                  hireController.isSecure.value = value!,
            ),
            Text("Secure this card. Why is it important?",
                style: GoogleFonts.ubuntu(fontSize: 16)),
          ],
        ));
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          backgroundColor: Colors.deepPurple,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final dabbawalaData = Get.arguments is Map<String, dynamic>
                ? Get.arguments as Map<String, dynamic>
                : {};

            // 🚀 Navigate to the Payment Screen
            Get.to(() => PaymentScreen(
                  onPaymentSuccess: (plan, amount) async {
                    Get.dialog(const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false);

                    final response = await hireController.hireDabbawala(
                      customerId: "805747c1-3412-4748-bead-677205f81630",
                      dabbawalaId: dabbawalaData['id'] ?? '',
                      schedule: hireController.selectedSchedule.value,
                      fromDate: DateFormat('yyyy-MM-dd')
                          .format(hireController.selectedDate.value!),
                    );

                    Get.back();

                    if (response['success']) {
                      Get.snackbar(
                        "Success",
                        "Dabbawala hired successfully!",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        response['message'] ?? "Failed to hire dabbawala.",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ));
          }
        },
        child: Text("Pay Now",
            style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}
