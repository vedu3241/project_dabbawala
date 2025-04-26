import 'dart:convert';

import 'package:dabbawala/features/MyCustomers/model/hireReqModel.dart';
import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DabbawalaHireRequestsApiService {
  final box = GetStorage();
  Future<List<HireRequest>> fetchHireRequests() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    try {
      String userId = box.read('user_id');
      final response = await http.get(
        Uri.parse(
            '${UsedConstants.baseUrl}/customer/fetchHireReqByDabId/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if data is not empty
        if (data != null && data is List && data.isNotEmpty) {
          return List<HireRequest>.from(
              data.map((x) => HireRequest.fromJson(x)));
        } else {
          // Return empty list if there's no hire request
          return [];
        }
      } else {
        throw Exception('Failed to load hire requests');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      // Return empty list in case of an error
      return [];
    }
  }

  updateStatus(String hireReqId, String status, BuildContext context) async {
    try {
      String url = '${UsedConstants.baseUrl}/customer/updateHireStatus';
      final response = await http.post(Uri.parse(url),
          body: {"hireReqId": hireReqId, "status": status});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Request $status')));
        print(data['message']);
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      debugPrint('Error updating hire req status : $e');
      // Return empty list in case of an error
      return [];
    }
  }
}
