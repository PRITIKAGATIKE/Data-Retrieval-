// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/admin_dashboard.dart';
import 'Screens/driver_dashboard.dart';
import 'Services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truck DBMS',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InitialScreen(), // App entry point
    );
  }
}

/// Checks if user is already logged in and navigates accordingly
class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final AuthService authService = AuthService();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    redirectUser();
  }

  Future<void> redirectUser() async {
    final user = authService.currentUser;
    if (user != null) {
      final role = await authService.getUserRole(user.uid);
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else if (role == 'driver') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DriverDashboard(driverId: user.uid)),
        );
      }
    }
    setState(() => loading = false); // Show login screen if not logged in
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : const LoginScreen();
  }
}
