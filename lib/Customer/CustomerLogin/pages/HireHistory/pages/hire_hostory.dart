import 'package:dabbawala/Customer/CustomerLogin/pages/HireHistory/controller/hire_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HireHistoryScreen extends StatelessWidget {
  const HireHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HireHistoryController controller = Get.put(HireHistoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hire History"),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.hireHistoryList.isEmpty
            ? const Center(child: Text("No hire history found"))
            : ListView.builder(
                itemCount: controller.hireHistoryList.length,
                itemBuilder: (context, index) {
                  final hire = controller.hireHistoryList[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(hire.schedule[0].toUpperCase()),
                      ),
                      title: Text("Schedule: ${hire.schedule}"),
                      subtitle: Text("From Date: ${hire.fromDate}\nStatus: ${hire.status}"),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.green),
                          Text("${hire.expiryDate}", style: const TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
