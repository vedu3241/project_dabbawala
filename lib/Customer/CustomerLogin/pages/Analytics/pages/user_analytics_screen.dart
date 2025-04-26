import 'package:dabbawala/Customer/CustomerLogin/pages/Analytics/controller/cust_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserAnalyticsScreen extends StatelessWidget {
  final AnalyticsController controller = Get.put(AnalyticsController());

  UserAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Analytics"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// **Total Payments**
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.payment, color: Colors.blue),
                  title: const Text("Total Payments"),
                  subtitle: Text("₹${controller.totalPayments.value.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 15),

              /// **Total Dabbawalas Hired**
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.delivery_dining, color: Colors.green),
                  title: const Text("Dabbawalas Hired"),
                  subtitle: Text("${controller.dabbawalasHired.value}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 15),

              /// **User Feedback Section**
              const Text("User Feedback:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: controller.userFeedback.isEmpty
                    ? const Center(child: Text("No feedback available"))
                    : ListView.builder(
                        itemCount: controller.userFeedback.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                controller.userFeedback[index],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
