import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/controller/hire_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomerFormScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final CustomerController controller = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hire Dabbawala")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Customer Name"),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Customer Address"),
                validator: (value) => value!.isEmpty ? 'Enter address' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Customer Mobile No"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Enter mobile number' : null,
              ),
              
              Obx(() => DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Schedule"),
                    value: controller.selectedSchedule.value, // Set initial value
                    items: ["Yearly", "Monthly", "Weekly"].map((String schedule) {
                      return DropdownMenuItem<String>(
                        value: schedule,
                        child: Text(schedule),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedSchedule.value = value!;
                    },
                  )),

              Obx(() => ListTile(
                    title: Text(controller.selectedDate.value == null
                        ? "Select Date"
                        : "Selected Date: ${controller.selectedDate.value!.toLocal().toString().split(' ')[0]}"), // Formatting fix
                    trailing: Icon(Icons.calendar_today),
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
                  )),

              Text("List of Dabbawalas", style: TextStyle(fontWeight: FontWeight.bold)),

              // Wrap only ListView.builder in Obx
              // Expanded(
              //   child: Obx(() => ListView.builder(
              //         itemCount: controller.dabbawalas.length,
              //         itemBuilder: (context, index) {
              //           return ListTile(
              //             title: Text(controller.dabbawalas[index]['name']!),
              //             subtitle: Text(controller.dabbawalas[index]['email']!),
              //             leading: Icon(Icons.person),
              //           );
              //         },
              //       )),
              // ),

              SizedBox(height: 150),

              ElevatedButton(
                style: ButtonStyle(
                  
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
