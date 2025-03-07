import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String id;
  final String name;
  final String username;
  final String mobileNo;
  final String address;
  final String profilePicUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.mobileNo,
    required this.address,
    required this.profilePicUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      address: json['address'] ?? '',
      profilePicUrl: json['profile_pic_url'] ?? '',
    );
  }
}