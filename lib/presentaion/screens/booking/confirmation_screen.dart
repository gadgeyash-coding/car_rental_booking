import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_strings.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.successGreen,
                size: 100,
              ),
              SizedBox(height: 24),
              Text(
                AppStrings.successMsg,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              Text(
                AppStrings.successSub,
                style: TextStyle(color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  child: Text(
                    AppStrings.backToHome,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
