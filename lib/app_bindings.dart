import 'package:get/get.dart';

import 'Customer/CustomerLogin/pages/Hire/controller/hire_controller.dart';
import 'Customer/CustomerLogin/pages/HireHistory/controller/hire_history_controller.dart';
import 'Customer/CustomerLogin/pages/Notification/controller/customer_notification.dart';
import 'features/HireRequest/controller/dabbawala_request_controller.dart';
// import 'features/Hire/controller/request_controller.dart';


class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize controllers
    Get.put(HireHistoryController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(HireController(), permanent: true);
    Get.put(DabbawalaRequestController(), permanent: true);
  }
}