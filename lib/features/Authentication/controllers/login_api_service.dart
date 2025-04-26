import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dabbawala/utils/constants/used_constants.dart';

import '../../../utils/helpers/helper_functions.dart';

class LoginApiService {
  Future<bool> verifyOtp(String otp) async {
    print(otp);
    try {
      final String url = '${UsedConstants.baseUrl}/auth/verify-otp';
      final Map<String, String> header = {
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {"otp": otp};

      final response = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(body));

      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        // Store the access_token in GetStorage
        final box = GetStorage();
        box.write('access_token', responseData['access_token']);
        box.write('user_id', responseData['user']['id']);

        // Return true indicating the login was successful
        return true;
      } else {
        // Handle login failure
        THelperFunctions.showSnackBar(responseData['error']);
        return false;
      }
    } catch (err) {
      print(err);
      THelperFunctions.showSnackBar("An error occurred. Please try again.");
      return false;
    }
  }

  Future<bool> getOtp(String mobileNo) async {
    try {
      final String url = '${UsedConstants.baseUrl}/auth/login-with-otp';
      final Map<String, String> header = {
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {"mobile": "+91$mobileNo"};

      final response = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(body));

      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        // Return true indicating the login was successful
        THelperFunctions.showSnackBar("OTP Sent Successfully!");
        return true;
      } else {
        // Handle login failure
        THelperFunctions.showSnackBar(responseData['error']);
        return false;
      }
    } catch (err) {
      print(err);
      THelperFunctions.showSnackBar("An error occurred. Please try again.");
      return false;
    }
  }
}
