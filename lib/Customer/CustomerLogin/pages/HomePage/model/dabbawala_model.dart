
class DabbawalaResponse {
  final List<Dabbawala> users;
  final int page;
  final int limit;

  DabbawalaResponse({
    required this.users,
    required this.page,
    required this.limit,
  });

  factory DabbawalaResponse.fromMap(Map<String, dynamic> json) => DabbawalaResponse(
        users: List<Dabbawala>.from(json["users"].map((x) => Dabbawala.fromMap(x))),
        page: json["page"] ?? 0,
        limit: json["limit"] ?? 0,
      );
}

class Dabbawala {
  final String id;
  final String name;
  final String mobile_no;
  final String address;
  final String city;
  final String? profilePicUrl;

  Dabbawala({
    required this.id,
    required this.name,
    required this.mobile_no,
    required this.address,
    required this.city,
    this.profilePicUrl,
  });

 factory Dabbawala.fromMap(Map<String, dynamic> map) {
  try {
    return Dabbawala(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      mobile_no: (map['mobile_no'] ?? '').toString().trim(), // corrected here
      address: (map['address'] ?? '').toString(),
      city: (map['city'] ?? '').toString(),
      profilePicUrl: map['profilePicUrl']?.toString(),
    );
  } catch (e) {
    print("Error parsing Dabbawala: $e\nData: $map");
    rethrow;
  }
}



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobileNo': mobile_no,
      'address': address,
      'city': city,
      'profilePicUrl': profilePicUrl,
    };
  }
}
