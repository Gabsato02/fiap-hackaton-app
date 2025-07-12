import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String id;
  final String title;
  final String type; // 'sales' ou 'production'
  final num targetValue;
  num currentValue;
  final DateTime startDate;
  final DateTime endDate;
  final String userId;

  Goal({
    required this.id,
    required this.title,
    required this.type,
    required this.targetValue,
    this.currentValue = 0,
    required this.startDate,
    required this.endDate,
    required this.userId,
  });

  factory Goal.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Goal(
      id: doc.id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      targetValue: data['targetValue'] ?? 0,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'targetValue': targetValue,
      'startDate': startDate,
      'endDate': endDate,
      'userId': userId,
    };
  }
}
