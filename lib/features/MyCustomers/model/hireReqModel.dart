class HireRequest {
  final String id;
  final String customerId;
  final String schedule;
  final String dabbewalaId;
  final DateTime fromDate;
  final DateTime createdAt;
  final String status;
  final String? note;

  HireRequest({
    required this.id,
    required this.customerId,
    required this.schedule,
    required this.dabbewalaId,
    required this.fromDate,
    required this.createdAt,
    required this.status,
    this.note,
  });

  factory HireRequest.fromJson(Map<String, dynamic> json) {
    return HireRequest(
      id: json['id'],
      customerId: json['customer_id'],
      schedule: json['schedule'],
      dabbewalaId: json['dabbewala_id'],
      fromDate: DateTime.parse(json['from_date']),
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'],
      note: json['note'],
    );
  }
}
