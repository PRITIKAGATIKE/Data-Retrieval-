import 'package:cloud_firestore/cloud_firestore.dart';

class Truck {
  final String? id;
  final String name;
  final String licensePlate;
  final String driverId;

  Truck({this.id, required this.name, required this.licensePlate, required this.driverId});

  Map<String, dynamic> toMap() => {
    'name': name,
    'licensePlate': licensePlate,
    'driverId': driverId,
  };

  factory Truck.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Truck(
      id: doc.id,
      name: data['name'],
      licensePlate: data['licensePlate'],
      driverId: data['driverId'],
    );
  }
}
