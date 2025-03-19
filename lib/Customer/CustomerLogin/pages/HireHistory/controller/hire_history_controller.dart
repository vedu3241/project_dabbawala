// hire_history_controller.dart

import 'dart:convert';
import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/model/hire_dabbawala_model.dart';
import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class HireHistoryController extends GetxController {
  var hireHistoryList = <HireHistory>[].obs;

void onInit() {
    super.onInit();
    fetchHireHistory(1,10);
  }
  Future<void> fetchHireHistory(int page, int limit) async {
    try {
      final response = await http.get(
        Uri.parse('${UsedConstants.baseUrl}/customer/hireHistory'
            '?customer_id=805747c1-3412-4748-bead-677205f81630'
            '&page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        hireHistoryList.value = List<HireHistory>.from(
          data['hireHistory'].map((x) => HireHistory.fromJson(x)),
        );
      } else {
        throw Exception('Failed to fetch hire history');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
