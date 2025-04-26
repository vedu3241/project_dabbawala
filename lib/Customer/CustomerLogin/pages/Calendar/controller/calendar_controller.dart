import 'package:dabbawala/Customer/CustomerLogin/pages/Calendar/model/calendar_model.dart';
import 'package:get/get.dart';

import '../../HomePage/model/dabbawala_model.dart';


class CalendarController extends GetxController {
  var hiredDabbawalasList = <HiredDabbawala>[].obs;

  /// **Function to Add a Hired Dabbawala with Start & End Dates**
  void addHiredDabbawala(Dabbawala dabbawala, DateTime startDate, DateTime endDate) {
    hiredDabbawalasList.add(HiredDabbawala(
      id: dabbawala.id,
      name: dabbawala.name,
      startDate: startDate,
      endDate: endDate,
    ));
  }
}