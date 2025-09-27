// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Login with email & password
  Future<User?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  /// Register a new user with role (admin/driver)
  Future<User?> register(String email, String password, String role) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save user role in Firestore
    await _db.collection('users').doc(credential.user!.uid).set({
      'email': email,
      'role': role,
    });

    return credential.user;
  }

  /// Logout current user
  Future<void> logout() async => await _auth.signOut();

  /// Get current logged-in user
  User? get currentUser => _auth.currentUser;

  /// Fetch user role from Firestore
  Future<String?> getUserRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data()?['role'];
    }
    return null;
  }
}
