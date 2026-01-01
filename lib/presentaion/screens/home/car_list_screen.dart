import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/car_model.dart';
import '../../../providers/booking_provider.dart';
import '../booking/history_screen.dart';
import '../details/car_detail_screen.dart';

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        title: const Text(AppStrings.fleetTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: mockCars.length,
          itemBuilder: (context, index) {
            final car = mockCars[index];
            return GestureDetector(
              onTap: () {
                if (car.isAvailable) {
                  // Agar car available hai toh navigate karo
                  context.read<BookingProvider>().selectCar(car);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CarDetailScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sorry, ${car.name} is already booked!"),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Car Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            car.image,
                            width: 100,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, size: 50),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Car Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(car.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                  // Availability Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: car.isAvailable ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      car.isAvailable ? "Available" : "Booked",
                                      style: TextStyle(color: car.isAvailable ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Text(car.brand, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                              const SizedBox(height: 5),
                              Text("₹${car.price.toInt()}/day", style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, thickness: 0.5),
                    ),
                    // Minimal Specs Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSpecItem(Icons.airline_seat_recline_normal, "${car.seats} Seats"),
                        _buildSpecItem(Icons.settings_input_component, car.transmission),
                        _buildSpecItem(Icons.local_gas_station, car.fuelType),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}