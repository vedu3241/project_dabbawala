import 'dart:convert';

class DabbawalaResponse {
  final List<Dabbawala> users;
  final int page;
  final int limit;

  DabbawalaResponse({
    required this.users,
    required this.page,
    required this.limit,
  });

  factory DabbawalaResponse.fromJson(String str) =>
      DabbawalaResponse.fromMap(json.decode(str));

  factory DabbawalaResponse.fromMap(Map<String, dynamic> json) => DabbawalaResponse(
        users: List<Dabbawala>.from(json["users"].map((x) => Dabbawala.fromMap(x))),
        page: json["page"],
        limit: json["limit"],
      );
}

class Dabbawala {
  final String id;
  final String name;
  final String mobileNo;
  final String username;
  final String address;
  final String? profilePicUrl;
  final DateTime createdAt;
  final int accessId;
  final String city;

  Dabbawala({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.username,
    required this.address,
    this.profilePicUrl,
    required this.createdAt,
    required this.accessId,
    required this.city,
  });

  factory Dabbawala.fromJson(String str) => Dabbawala.fromMap(json.decode(str));

  factory Dabbawala.fromMap(Map<String, dynamic> json) => Dabbawala(
        id: json["id"],
        name: json["name"],
        mobileNo: json["mobile_no"].trim(),
        username: json["username"],
        address: json["address"],
        profilePicUrl: json["profile_pic_url"],
        createdAt: DateTime.parse(json["created_at"]),
        accessId: json["access_id"],
        city: json["city"],
      );
}
