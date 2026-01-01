import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/booking_provider.dart';
import '../booking/confirmation_screen.dart';

class CarDetailScreen extends StatelessWidget {
  final nameCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final locCtrl = TextEditingController(); // Location ke liye naya controller
  final _formKey = GlobalKey<FormState>();

  CarDetailScreen({super.key});

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (d != null) {
      final TimeOfDay? t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (t != null) {
        dateCtrl.text = "${d.day}/${d.month}/${d.year} at ${t.format(context)}";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = context.watch<BookingProvider>().selectedCar!;

    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        title: const Text(AppStrings.carDetails, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Image with Shadow
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(car.image, height: 220, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 24),
        
                // Title & Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(car.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                        Text(car.brand, style: const TextStyle(color: AppColors.textGrey, fontSize: 16)),
                      ],
                    ),
                    Text("₹${car.price.toInt()}/day", style: const TextStyle(fontSize: 22, color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
        
                // Horizontal Specs Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSpecCard(Icons.airline_seat_recline_normal, "${car.seats} Seats"),
                    _buildSpecCard(Icons.settings_input_component, car.transmission),
                    _buildSpecCard(Icons.local_gas_station, car.fuelType),
                  ],
                ),
                const Divider(height: 40),
        
                // Booking Form Fields
                Text(AppStrings.bookingForm, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
        
                // Name Field
                _buildTextField(nameCtrl, AppStrings.nameLabel, Icons.person_outline),
                const SizedBox(height: 16),
        
                // Location Field (New)
                _buildTextField(locCtrl, "Pickup Location", Icons.location_on_outlined),
                const SizedBox(height: 16),
        
                // Date Field
                TextFormField(
                  controller: dateCtrl,
                  readOnly: true,
                  onTap: () => _selectDateTime(context),
                  validator: (value) => value!.isEmpty ? AppStrings.errorFillFields : null,
                  decoration: InputDecoration(
                    labelText: AppStrings.dateLabel,
                    prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primaryBlue),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
        
                const SizedBox(height: 40),
        
                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Note: Location ko bhi string me include kar diya history ke liye
                        await context.read<BookingProvider>().addBooking(
                          "${car.name} booked by ${nameCtrl.text} at ${locCtrl.text} on ${dateCtrl.text}",
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfirmationScreen()));
                      }
                    },
                    child: const Text(AppStrings.confirmBtn, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for Specs Bar
  Widget _buildSpecCard(IconData icon, String label) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 24),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // Helper for consistent TextFields
  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon) {
    return TextFormField(
      controller: ctrl,
      validator: (value) => value!.isEmpty ? AppStrings.errorFillFields : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryBlue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}