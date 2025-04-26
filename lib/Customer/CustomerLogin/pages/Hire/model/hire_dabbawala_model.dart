// // Hire Dabbawala Model
// class HireDabbawala {
//   final String id;
//   final String customerId;
//   final String schedule;
//   final String dabbawalaId;
//   final String fromDate;
//   final DateTime createdAt;

//   HireDabbawala({
//     required this.id,
//     required this.customerId,
//     required this.schedule,
//     required this.dabbawalaId,
//     required this.fromDate,
//     required this.createdAt,
//   });

//   factory HireDabbawala.fromJson(Map<String, dynamic> json) => HireDabbawala(
//         id: json['id'],
//         customerId: json['customer_id'],
//         schedule: json['schedule'],
//         dabbawalaId: json['dabbewala_id'],
//         fromDate: json['from_date'],
//         createdAt: DateTime.parse(json['created_at']),
//       );
// }

// // Hire History Model
// class HireHistory {
//   final String id;
//   final String customerId;
//   final String schedule;
//   final String dabbawalaId;
//   final String fromDate;
//   final DateTime createdAt;
//   final String expiryDate;
//   final String status;

//   HireHistory({
//     required this.id,
//     required this.customerId,
//     required this.schedule,
//     required this.dabbawalaId,
//     required this.fromDate,
//     required this.createdAt,
//     required this.expiryDate,
//     required this.status,
//   });

//   factory HireHistory.fromJson(Map<String, dynamic> json) => HireHistory(
//         id: json['id'],
//         customerId: json['customer_id'],
//         schedule: json['schedule'],
//         dabbawalaId: json['dabbewala_id'],
//         fromDate: json['from_date'],
//         createdAt: DateTime.parse(json['created_at']),
//         expiryDate: json['expiryDate'],
//         status: json['status'],
//       );
// }





import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/model/dabbawala_model.dart';

class HireRequest {
  final String requestId;
  final String dabbawalaId;
  final String customerId;
  final String schedule; // Monthly, Weekly, Yearly
  late final String status; // Pending, Accepted, Rejected
  final String fromDate;
  final String expiryDate;
  final Dabbawala dabbawalaDetails;
  final Map<String, dynamic> customerDetails;
  final String requestDate;
  String? rejectionReason;

  HireRequest({
    required this.requestId,
    required this.dabbawalaId,
    required this.customerId,
    required this.schedule,
    required this.status,
    required this.fromDate,
    required this.expiryDate,
    required this.dabbawalaDetails,
    required this.customerDetails,
    required this.requestDate,
    this.rejectionReason, required String id, required String subscriptionType,
  });

  // Convert to a map
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'dabbawalaId': dabbawalaId,
      'customerId': customerId,
      'schedule': schedule,
      'status': status,
      'fromDate': fromDate,
      'expiryDate': expiryDate,
      'dabbawalaDetails': dabbawalaDetails.toMap(),
      'customerDetails': customerDetails,
      'requestDate': requestDate,
      'rejectionReason': rejectionReason,
    };
  }

  // Create from a map
  factory HireRequest.fromMap(Map<String, dynamic> map) {
    return HireRequest(
      requestId: map['requestId'],
      dabbawalaId: map['dabbawalaId'],
      customerId: map['customerId'],
      schedule: map['schedule'],
      status: map['status'],
      fromDate: map['fromDate'],
      expiryDate: map['expiryDate'],
      dabbawalaDetails: Dabbawala.fromMap(map['dabbawalaDetails']),
      customerDetails: map['customerDetails'],
      requestDate: map['requestDate'],
      rejectionReason: map['rejectionReason'], id: '', subscriptionType: '',
    );
  }

  // Create a copy with updated fields
  HireRequest copyWith({
    String? status,
    String? rejectionReason,
  }) {
    return HireRequest(
      requestId: requestId,
      dabbawalaId: dabbawalaId,
      customerId: customerId,
      schedule: schedule,
      status: status ?? this.status,
      fromDate: fromDate,
      expiryDate: expiryDate,
      dabbawalaDetails: dabbawalaDetails,
      customerDetails: customerDetails,
      requestDate: requestDate,
      rejectionReason: rejectionReason ?? this.rejectionReason, id: '', subscriptionType: '',
    );
  }
}