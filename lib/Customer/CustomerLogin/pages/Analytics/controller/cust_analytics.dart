import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalyticsController extends GetxController {
  var totalPayments = 0.0.obs;
  var dabbawalasHired = 0.obs;
  var userFeedback = [].obs; // List to store feedback messages

  @override
  void onInit() {
    super.onInit();
    fetchUserAnalytics();
  }

  /// **Fetch Analytics Data from API**
  Future<void> fetchUserAnalytics() async {
    try {
      final response = await http.get(Uri.parse("https://yourapi.com/user/analytics"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        totalPayments.value = data["total_payments"];
        dabbawalasHired.value = data["dabbawalas_hired"];
        userFeedback.assignAll(List<String>.from(data["feedback"]));
      } else {
        Get.snackbar("Error", "Failed to load analytics data");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}
