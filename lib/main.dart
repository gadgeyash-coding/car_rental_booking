import 'package:car_rental_booking_app/core/constants/app_strings.dart';
import 'package:car_rental_booking_app/presentaion/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_color.dart';
import 'providers/booking_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BookingProvider())],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryBlue,
          useMaterial3: true,
          fontFamily: AppStrings.googleFonts,
        ),
        home: SplashScreen(),
      ),
    ),
  );
}
