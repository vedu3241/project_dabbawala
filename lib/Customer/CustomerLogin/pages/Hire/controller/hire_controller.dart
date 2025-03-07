import 'package:get/get.dart';

class CustomerController extends GetxController {
  var selectedSchedule = "".obs;
  var selectedDate = Rxn<DateTime>();
  var isSecure = false.obs;
  var dabbawalas = <Map<String, String>>[].obs;
  List<Map<String, String>> dabbawalasList = [
    {'name': 'Ramesh Kumar', 'email': 'ramesh@example.com'},
    {'name': 'Suresh Patil', 'email': 'suresh@example.com'},
    {'name': 'Amit Sharma', 'email': 'amit@example.com'},
  ];
  
  // Add selected dabbawala info
  var selectedDabbawala = Rxn<Map<String, dynamic>>();
  
  @override
  void onInit() {
    super.onInit();
    
    // Check if arguments were passed
    if (Get.arguments != null) {
      selectedDabbawala.value = Get.arguments as Map<String, dynamic>;
    }
  }
}