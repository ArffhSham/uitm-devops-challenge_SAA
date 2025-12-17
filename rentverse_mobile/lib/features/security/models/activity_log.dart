class ActivityLog {
  final String action;
  final String status;
  final DateTime createdAt;

  ActivityLog({
    required this.action,
    required this.status,
    required this.createdAt,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      action: json['action'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}