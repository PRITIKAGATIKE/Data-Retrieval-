// lib/screens/driver_dashboard.dart
import 'package:flutter/material.dart';
import '../Services/firestore_services.dart';
import '../Models/truck.dart';
import '../Widgets/custom_card.dart';
import 'maintainance_form_screen.dart';
import 'Maintainance_history_screen.dart';


class DriverDashboard extends StatefulWidget {
  final String driverId;
  const DriverDashboard({super.key, required this.driverId});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  final FirestoreService firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Dashboard')),
      body: StreamBuilder<List<Truck>>(
        stream: firestore.getTrucks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No trucks assigned.'));
          }

          // Filter trucks by driverId
          final trucks = snapshot.data!.where((t) => t.driverId == widget.driverId).toList();

          if (trucks.isEmpty) {
            return const Center(child: Text('No trucks assigned.'));
          }

          return ListView.builder(
            itemCount: trucks.length,
            itemBuilder: (context, index) {
              final truck = trucks[index];
              return CustomCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${truck.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('License: ${truck.licensePlate}'),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_task, color: Colors.green),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MaintenanceFormScreen(truckId: truck.id!),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.history, color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MaintenanceHistoryScreen(truckId: truck.id!),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

