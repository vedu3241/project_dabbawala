import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  var selectedSchedule = 'Monthly'.obs; // Default value set
  var selectedDate = Rx<DateTime?>(null);

  List<Map<String, String>> dabbawalas = [
    {'name': 'Ramesh Kumar', 'email': 'ramesh@example.com'},
    {'name': 'Suresh Patil', 'email': 'suresh@example.com'},
    {'name': 'Amit Sharma', 'email': 'amit@example.com'},
  ];
}