// // hire_history_controller.dart

// import 'dart:convert';
// import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/model/hire_dabbawala_model.dart';
// import 'package:dabbawala/utils/constants/used_constants.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;


// class HireHistoryController extends GetxController {
//   var hireHistoryList = <HireHistory>[].obs;

// void onInit() {
//     super.onInit();
//     fetchHireHistory(1,10);
//   }
//   Future<void> fetchHireHistory(int page, int limit) async {
//     try {
//       final response = await http.get(
//         Uri.parse('${UsedConstants.baseUrl}/customer/hireHistory'
//             '?customer_id=805747c1-3412-4748-bead-677205f81630'
//             '&page=$page&limit=$limit'),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         hireHistoryList.value = List<HireHistory>.from(
//           data['hireHistory'].map((x) => HireHistory.fromJson(x)),
//         );
//       } else {
//         throw Exception('Failed to fetch hire history');
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
// }


import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Hire/model/hire_dabbawala_model.dart';


class HireHistoryController extends GetxController {
  // List of hire requests
  final RxList<HireRequest> hireHistoryList = <HireRequest>[].obs;
  bool isLoading = false;

  @override
  void onInit() {
    fetchHireHistory();
    super.onInit();
  }


   Future<void> fetchHireHistory() async {
    try {
      isLoading = true;
      update();
      
      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('http://172.16.2.16:5000/api/customer/hireHistory?customer_id=b436e769-6946-4ed2-b1c6-36a8d1fd3a64&page=1&limit=5'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Replace with actual auth
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        hireHistoryList.clear();
        hireHistoryList.addAll(data as Iterable<HireRequest>);
      } else {
        print('Failed to load hire history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching hire history: $e');
    } finally {
      isLoading = false;
      update(); // This will rebuild the UI with updated data
    }
  }
  // Add a hire request to history
  void addHireRequest(HireRequest request) {
    hireHistoryList.add(request);
  }

 void updatePendingRequestsStatus() {
    for (var request in hireHistoryList) {
      if (request.status == 'Pending') {
        // Use 'Accepted' instead of 'Hired' for consistency with UI
        updateHireRequestStatus(request.requestId, 'Accepted');
      }
    }
    update();  // Rebuild only the necessary widgets
  }
  
  // Update a hire request status
  void updateHireRequestStatus(String requestId, String status, {String? rejectionReason}) {
    final index = hireHistoryList.indexWhere((req) => req.requestId == requestId);
    if (index != -1) {
      final updatedRequest = hireHistoryList[index].copyWith(
        status: status,
        rejectionReason: rejectionReason,
      );
      hireHistoryList[index] = updatedRequest;
      update(); // Make sure UI is updated when a status changes
    }
  }
}