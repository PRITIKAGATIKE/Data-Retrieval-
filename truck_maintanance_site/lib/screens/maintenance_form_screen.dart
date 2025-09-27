// lib/screens/maintenance_form_screen.dart
import 'package:flutter/material.dart';
import '../Services/firestore_services.dart';
import '../Models/maintainance.dart';
import '../Widgets/custom_button.dart';

class MaintenanceFormScreen extends StatefulWidget {
  final String truckId;
  const MaintenanceFormScreen({super.key, required this.truckId});

  @override
  State<MaintenanceFormScreen> createState() => _MaintenanceFormScreenState();
}

class _MaintenanceFormScreenState extends State<MaintenanceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final FirestoreService firestore = FirestoreService();
  DateTime selectedDate = DateTime.now();
  bool loading = false;

  void saveMaintenance() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    final maintenance = Maintenance(
      truckId: widget.truckId,
      description: descriptionController.text.trim(),
      date: selectedDate,
    );

    try {
      await firestore.addMaintenance(maintenance);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Maintenance')),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter description' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                    TextButton(onPressed: pickDate, child: const Text('Pick Date')),
                  ],
                ),
                const SizedBox(height: 20),
                loading
                    ? const CircularProgressIndicator()
                    : CustomButton(text: 'Save', onPressed: saveMaintenance),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
