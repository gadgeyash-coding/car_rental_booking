import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/car_model.dart';
import '../../../providers/booking_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final history = provider.history;

    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        title: const Text(AppStrings.historyTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: history.isEmpty
          ? const Center(child: Text(AppStrings.noHistory))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          // Parsing logic for: "Car booked by Name at Location on Date"
          final parts = history[index].split(' booked by ');
          final carName = parts[0];
          final rest = parts.length > 1 ? parts[1].split(' at ') : ["User", "Location on Date"];
          final userName = rest[0];
          final locationAndDate = rest.length > 1 ? rest[1].split(' on ') : ["Unknown", "Date"];
          final location = locationAndDate[0];
          final date = locationAndDate.length > 1 ? locationAndDate[1] : "";

          final carObj = mockCars.firstWhere(
                (c) => c.name == carName,
            orElse: () => mockCars[0],
          );

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(carObj.image, width: 70, height: 70, fit: BoxFit.cover),
                  ),
                  title: Text(carName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Customer: $userName", style: const TextStyle(fontSize: 13)),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: AppColors.primaryBlue),
                          const SizedBox(width: 4),
                          Text(location, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) => value == 'edit'
                        ? _showSmartEditDialog(context, index, history[index])
                        : provider.deleteBooking(index),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text("Edit")])),
                      const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: AppColors.primaryBlue),
                      const SizedBox(width: 8),
                      Text(date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      const Text("BOOKED", style: TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSmartEditDialog(BuildContext context, int index, String currentData) {
    // Re-parsing for Edit Dialog
    final parts = currentData.split(' booked by ');
    final carName = parts[0];
    final rest = parts.length > 1 ? parts[1].split(' at ') : ["", ""];
    final userName = rest[0];
    final locAndDate = rest.length > 1 ? rest[1].split(' on ') : ["", ""];

    final nameEditCtrl = TextEditingController(text: userName);
    final locEditCtrl = TextEditingController(text: locAndDate[0]);
    final dateEditCtrl = TextEditingController(text: locAndDate.length > 1 ? locAndDate[1] : "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Edit Booking Info", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField(nameEditCtrl, "Name", Icons.person),
              const SizedBox(height: 12),
              _buildEditField(locEditCtrl, "Location", Icons.location_on),
              const SizedBox(height: 12),
              TextField(
                controller: dateEditCtrl,
                readOnly: true,
                onTap: () async {
                  DateTime? d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
                  if (d != null) {
                    TimeOfDay? t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (t != null) dateEditCtrl.text = "${d.day}/${d.month}/${d.year} at ${t.format(context)}";
                  }
                },
                decoration: InputDecoration(
                  labelText: "Date",
                  prefixIcon: const Icon(Icons.calendar_month, color: AppColors.primaryBlue),
                  filled: true, fillColor: AppColors.bgGrey,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              String updated = "$carName booked by ${nameEditCtrl.text} at ${locEditCtrl.text} on ${dateEditCtrl.text}";
              context.read<BookingProvider>().editBooking(index, updated);
              Navigator.pop(context);
            },
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(TextEditingController ctrl, String label, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryBlue),
        filled: true, fillColor: AppColors.bgGrey,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}