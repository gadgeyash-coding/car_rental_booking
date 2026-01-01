import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car_model.dart';

class BookingProvider extends ChangeNotifier {
  Car? _selectedCar;
  List<String> _history = [];

  Car? get selectedCar => _selectedCar;

  List<String> get history => _history;

  BookingProvider() {
    _loadFromPrefs();
  }

  void selectCar(Car car) {
    _selectedCar = car;
    notifyListeners();
  }

  Future<void> addBooking(String details) async {
    _history.insert(0, details);
    _saveToPrefs();
  }

  Future<void> editBooking(int index, String newVal) async {
    _history[index] = newVal;
    _saveToPrefs();
  }

  Future<void> deleteBooking(int index) async {
    _history.removeAt(index);
    _saveToPrefs();
  }

  void _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookings', _history);
    notifyListeners();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList('bookings') ?? [];
    notifyListeners();
  }
}
