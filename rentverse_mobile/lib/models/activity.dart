// lib/models/activity.dart

class Activity {
  final String id;
  final String userId;
  final String action;
  final String timestamp;
  final bool success;

  Activity({
    required this.id,
    required this.userId,
    required this.action,
    required this.timestamp,
    required this.success,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      action: json['action'] as String,
      timestamp: json['timestamp'] as String,
      success: json['success'] as bool,
    );
  }
}