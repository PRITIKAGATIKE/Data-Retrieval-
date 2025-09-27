// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/truck.dart';
import '../Models/maintainance.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ------------------- Trucks -------------------
  Future<void> addTruck(Truck truck) => _db.collection('trucks').add(truck.toMap());

  Future<void> updateTruck(String id, Truck truck) => _db.collection('trucks').doc(id).update(truck.toMap());

  Future<void> deleteTruck(String id) => _db.collection('trucks').doc(id).delete();

  Stream<List<Truck>> getTrucks() => _db.collection('trucks').snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Truck.fromFirestore(doc)).toList());

  // ------------------- Maintenance -------------------
  Future<void> addMaintenance(Maintenance m) => _db.collection('maintenance').add(m.toMap());

  /// Get maintenance by truckId; if truckId is empty, get all maintenance records
  Stream<List<Maintenance>> getMaintenanceByTruck(String truckId) {
    Query collection = _db.collection('maintenance');
    if (truckId.isNotEmpty) {
      collection = collection.where('truckId', isEqualTo: truckId);
    }
    return collection.snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Maintenance.fromFirestore(doc)).toList());
  }
}
