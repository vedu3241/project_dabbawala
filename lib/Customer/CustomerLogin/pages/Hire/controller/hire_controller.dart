// import 'package:get/get.dart';

// import '../../HomePage/model/dabbawala_model.dart';

// class HireController extends GetxController {
//   // Use a map to track requests with their status and details
//   RxMap<String, Map<String, dynamic>> hireRequests = <String, Map<String, dynamic>>{}.obs;
//   RxList<String> hiredDabbawalaIds = <String>[].obs;

//   var currentCustomerInfo = {}.obs;

//   void sendHireRequest(String dabbawalaId, String customerId, String plan, Dabbawala dabbawala) {
//     // Store more information about the request
//     hireRequests[dabbawalaId] = {
//       'customerId': customerId,
//       'plan': plan,
//       'status': 'pending',
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//       'dabbawalaInfo': {
//         'name': dabbawala.name,
//         // Add other relevant dabbawala info
//       }
//     };
//     update();
//     // TODO: Save to backend or Firebase with status 'pending'
//   }

//   void updateHireStatus(String dabbawalaId, String newStatus) {
//     if (hireRequests.containsKey(dabbawalaId)) {
//       if (newStatus == 'accepted') {
//         // Update the status in the requests map
//         hireRequests[dabbawalaId]!['status'] = 'accepted';
//         // Also add to hired list for easy access
//         hiredDabbawalaIds.add(dabbawalaId);
//       } else if (newStatus == 'rejected') {
//         hireRequests[dabbawalaId]!['status'] = 'rejected';
//       } else {
//         hireRequests[dabbawalaId]!['status'] = newStatus;
//       }
//       update();
//       // TODO: Update status in backend or Firebase
//     }
//   }

//   // Helper getter methods for easy filtering
//   List<String> get pendingDabbawalaIds => hireRequests.entries
//       .where((entry) => entry.value['status'] == 'pending')
//       .map((entry) => entry.key)
//       .toList();

//   List<String> get rejectedDabbawalaIds => hireRequests.entries
//       .where((entry) => entry.value['status'] == 'rejected')
//       .map((entry) => entry.key)
//       .toList();
// }

// hire_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dabbawala/utils/constants/used_constants.dart';
import '../../HomePage/model/dabbawala_model.dart';


class HireController extends GetxController {
  var currentCustomerInfo = {}.obs;
var hiredDabbawalas = <String>[];
  Future<void> sendHireRequest(
    String dabbawalaId,
    String customerId,
    String schedule,
    Dabbawala dabbawala,
  ) async {
    final Uri url = Uri.parse("${UsedConstants.baseUrl}/customer/hire"); 

    final body = {
      "customer_id": customerId,
      "dabbewala_id": dabbawalaId,
      "schedule": schedule.toLowerCase(), // Make sure it's in lowercase: weekly/monthly
      "from_date": DateTime.now().toIso8601String().split("T")[0], 
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        Get.snackbar("Success", jsonResponse['message'],backgroundColor: Colors.green);
      } else {
        Get.snackbar("Error", "Failed to hire dabbawala",backgroundColor: Colors.red);
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error sending request: $e");
      Get.snackbar("Error", "Something went wrong",backgroundColor: Colors.red);
    }
  }

  
}
