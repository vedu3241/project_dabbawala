import 'dart:convert';

import 'package:dabbawala/features/ProfilePage/model/user_profile_model.dart';
import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProfileApiService {
  Future<Profile> getProfile() async {
    print("getProfile");
    try {
      String userId = GetStorage().read('user_id');
      String url = "${UsedConstants.baseUrl}/profile/$userId";
      //headers
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('access_token')}'
      };
      final response = await http.get(Uri.parse(url), headers: header);
      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body);
        Profile profile = Profile.fromJson(decodedData['profile']);
        return profile;
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (err) {
      print("Catch in getProfile: $err");
      // Re-throw the error to be handled by the caller
      throw Exception('Error fetching profile: $err');
    }
  }
}
