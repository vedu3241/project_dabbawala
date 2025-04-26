import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/model/hire_dabbawala_model.dart';
import 'package:get/get.dart';


class DabbawalaRequestController extends GetxController {
  final RxList<HireRequest> pendingRequests = <HireRequest>[].obs;

  void addHireRequest(HireRequest request) {
    pendingRequests.add(request);
  }

  void updateStatus(String requestId, String status, {String? reason}) {
    final index = pendingRequests.indexWhere((req) => req.requestId == requestId);
    if (index != -1) {
      final updated = pendingRequests[index].copyWith(
        status: status,
        rejectionReason: reason,
      );
      pendingRequests[index] = updated;
    }
  }
}