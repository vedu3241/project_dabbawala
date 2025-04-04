import 'dart:convert';
import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/model/hire_dabbawala_model.dart';
import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HireController extends GetxController {
  var selectedSchedule = ''.obs;
  var selectedDate = Rxn<DateTime>();
  var isSecure = false.obs;

  Future<Map<String, dynamic>> hireDabbawala({
    required String customerId,
    required String dabbawalaId,
    required String schedule,
    required String fromDate,
  }) async {
    try {
      String url = '${UsedConstants.baseUrl}/customer/hire';
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('access_token')}'
      };
      Map<String, dynamic> body = {
        "customer_id": customerId,
        "schedule": schedule,
        "dabbewala_id": dabbawalaId,
        "from_date": "2025-03-13"
      };
      final response = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(body));

      if (!response.headers['content-type']!.contains('application/json')) {
        return {
          "success": false,
          "message": "Unexpected response from server."
        };
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Hire dab 200");
        final data = jsonDecode(response.body);
        print(data);
        return {"success": true, "message": data['message']};
      } else {
        final errorData = jsonDecode(response.body);
        // return {
        //   "success": false,
        //   "message": errorData['message'] ?? 'Failed to hire dabbawala'
        // };
        return {"success": true, "message": errorData['message']};
      }
    } catch (e) {
      print(e);
      return {"success": false, "message": e.toString()};
    }
  }

  Future<List<HireHistory>> fetchHireHistory(int page, int limit) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/customer/hireHistory'
            '?customer_id=805747c1-3412-4748-bead-677205f81630'
            '&page=$page&limit=$limit'),
      );

      if (!response.headers['content-type']!.contains('application/json')) {
        Get.snackbar("Error", "Unexpected response from server.");
        return [];
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<HireHistory>.from(
          data['hireHistory'].map((x) => HireHistory.fromJson(x)),
        );
      } else {
        throw Exception('Failed to fetch hire history');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return [];
    }
  }
}
