// Hire Dabbawala Model
class HireDabbawala {
  final String id;
  final String customerId;
  final String schedule;
  final String dabbawalaId;
  final String fromDate;
  final DateTime createdAt;

  HireDabbawala({
    required this.id,
    required this.customerId,
    required this.schedule,
    required this.dabbawalaId,
    required this.fromDate,
    required this.createdAt,
  });

  factory HireDabbawala.fromJson(Map<String, dynamic> json) => HireDabbawala(
        id: json['id'],
        customerId: json['customer_id'],
        schedule: json['schedule'],
        dabbawalaId: json['dabbewala_id'],
        fromDate: json['from_date'],
        createdAt: DateTime.parse(json['created_at']),
      );
}

// Hire History Model
class HireHistory {
  final String id;
  final String customerId;
  final String schedule;
  final String dabbawalaId;
  final String fromDate;
  final DateTime createdAt;
  final String expiryDate;
  final String status;

  HireHistory({
    required this.id,
    required this.customerId,
    required this.schedule,
    required this.dabbawalaId,
    required this.fromDate,
    required this.createdAt,
    required this.expiryDate,
    required this.status,
  });

  factory HireHistory.fromJson(Map<String, dynamic> json) => HireHistory(
        id: json['id'],
        customerId: json['customer_id'],
        schedule: json['schedule'],
        dabbawalaId: json['dabbewala_id'],
        fromDate: json['from_date'],
        createdAt: DateTime.parse(json['created_at']),
        expiryDate: json['expiryDate'],
        status: json['status'],
      );
}