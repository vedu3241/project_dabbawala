import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/controller/hire_controller.dart';

class CustomerFormScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final CustomerController controller = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    // ✅ Receive hired dabbawala details
    final dabbawalaData = Get.arguments as Map<String, dynamic>;

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
                // ✅ Display Hired Dabbawala Info
                buildDabbawalaInfo(dabbawalaData),
                SizedBox(height: 20),

                buildTextField("Customer Name"),
                buildTextField("Customer Address"),
                buildTextField("Customer Mobile No", keyboardType: TextInputType.phone),
               Row(
                  children: [
                    Expanded(child: buildDropdownField()), // ✅ Remove Obx here
                    SizedBox(width: 10),
                    Expanded(child: buildDatePicker(context)), // ✅ Remove Obx here
                  ],
                ),
                SizedBox(height: 20),

               buildSecureCheckbox(),
                SizedBox(height: 120),

                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Function to display the selected dabbawala's info
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
          // Dabbawala Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              dabbawalaData['imagePath'],
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 80, color: Colors.red);
              },
            ),
          ),
          SizedBox(width: 15),

          // Dabbawala Name, Area, and Rating
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dabbawalaData['name'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  dabbawalaData['area'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 5),
                RatingBarIndicator(
                  rating: dabbawalaData['rating'],
                  itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
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

  Widget buildTextField(String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: keyboardType,
        validator: (value) => value!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

   Widget buildDropdownField() {
    return Obx(() => DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Schedule",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      value: controller.selectedSchedule.value.isEmpty ? null : controller.selectedSchedule.value,
      items: ["Yearly", "Monthly", "Weekly"].map((String schedule) {
        return DropdownMenuItem<String>(
          value: schedule,
          child: Text(schedule),
        );
      }).toList(),
      onChanged: (value) => controller.selectedSchedule.value = value!,
    ));
  }

  // ✅ Date Picker needs Obx because it updates dynamically
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
          controller.selectedDate.value = picked;
        }
      },
      controller: TextEditingController(
        text: controller.selectedDate.value == null
            ? ""
            : DateFormat('MM/yyyy').format(controller.selectedDate.value!),
      ),
    ));
  }

 Widget buildSecureCheckbox() {
    return Obx(() => Row(
      children: [
        Checkbox(
          value: controller.isSecure.value,
          onChanged: (bool? value) {
            controller.isSecure.value = value!;
          },
        ),
        Text("Secure this card. Why is it important?",style: GoogleFonts.ubuntu(fontSize: 16,)),
      ],
    ));
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13),),
          backgroundColor: Colors.deepPurple,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text('Processing Data')),
            );
          }
        },
        child: Text("Submit", style: GoogleFonts.ubuntu(fontSize: 16,color: Colors.white)),
      ),
    );
  }
}
