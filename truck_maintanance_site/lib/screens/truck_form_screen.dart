// lib/screens/truck_form_screen.dart
import 'package:flutter/material.dart';
import '../Services/firestore_services.dart';
import '../models/truck.dart';
import '../widgets/custom_button.dart';

class TruckFormScreen extends StatefulWidget {
  final Truck? truck;
  const TruckFormScreen({super.key, this.truck});

  @override
  State<TruckFormScreen> createState() => _TruckFormScreenState();
}

class _TruckFormScreenState extends State<TruckFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController driverIdController = TextEditingController();
  final FirestoreService firestore = FirestoreService();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.truck != null) {
      nameController.text = widget.truck!.name;
      licenseController.text = widget.truck!.licensePlate;
      driverIdController.text = widget.truck!.driverId;
    }
  }

  void saveTruck() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    final truck = Truck(
      id: widget.truck?.id,
      name: nameController.text.trim(),
      licensePlate: licenseController.text.trim(),
      driverId: driverIdController.text.trim(),
    );

    try {
      if (widget.truck == null) {
        await firestore.addTruck(truck);
      } else {
        await firestore.updateTruck(truck.id!, truck);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.truck == null ? 'Add Truck' : 'Edit Truck')),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Truck Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter truck name' : null,
                ),
                TextFormField(
                  controller: licenseController,
                  decoration: const InputDecoration(labelText: 'License Plate'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter license plate' : null,
                ),
                TextFormField(
                  controller: driverIdController,
                  decoration: const InputDecoration(labelText: 'Driver ID'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter driver ID' : null,
                ),
                const SizedBox(height: 20),
                loading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: widget.truck == null ? 'Add Truck' : 'Update Truck',
                        onPressed: saveTruck,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
