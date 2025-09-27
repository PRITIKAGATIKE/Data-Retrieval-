// lib/screens/maintenance_history_screen.dart
import 'package:flutter/material.dart';
import '../Services/firestore_services.dart';
import '../Models/maintainance.dart';
import '../Widgets/custom_card.dart';

class MaintenanceHistoryScreen extends StatelessWidget {
  final String truckId;
  const MaintenanceHistoryScreen({super.key, required this.truckId});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance History')),
      body: StreamBuilder<List<Maintenance>>(
        stream: firestore.getMaintenanceByTruck(truckId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No maintenance records found.'));
          }

          final records = snapshot.data!;
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final m = records[index];
              return CustomCard(
                child: ListTile(
                  title: Text(m.description),
                  subtitle: Text('Date: ${m.date.toLocal().toString().split(' ')[0]}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
