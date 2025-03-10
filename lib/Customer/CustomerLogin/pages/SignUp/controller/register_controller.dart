import 'dart:convert';

import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:dabbawala/utils/helpers/helper_functions.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
class RegisterApiService {
  Future<bool> registerUser(String name, String username, String address, String mobileNo, String email, String password) async {
    try{
      final String url = '${UsedConstants.baseUrl2}/auth/customer-register';
      final Map<String, String> header = {
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        "name": name,
        "username": username,
        "address": address,
        "mobile_no": mobileNo,
        "email": email,
        "password": password,
      };

      final response = await http.post(Uri.parse(url),
      headers: header,
      body: jsonEncode(body));


    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      final box = GetStorage();
      box.write('access token', responseData['access_token']);
      box.write('user_id', responseData['user']['id']);

      return true;
    } else {
     THelperFunctions.showSnackBar(responseData['eror']);
    return false;
    }
    }catch(err){
      print(err);
      THelperFunctions.showSnackBar("An error occurred. Please try again.");
      return false;
      }
    }
  }
