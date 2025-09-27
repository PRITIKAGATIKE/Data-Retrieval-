import 'package:cloud_firestore/cloud_firestore.dart';

class Maintenance {
  final String? id;
  final String truckId;
  final String description;
  final DateTime date;

  Maintenance({this.id, required this.truckId, required this.description, required this.date});

  Map<String, dynamic> toMap() => {
    'truckId': truckId,
    'description': description,
    'date': date.toIso8601String(),
  };

  factory Maintenance.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Maintenance(
      id: doc.id,
      truckId: data['truckId'],
      description: data['description'],
      date: DateTime.parse(data['date']),
    );
  }
}
