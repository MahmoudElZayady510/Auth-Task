import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/widgets/custom_appBar.dart';
import '../../../core/configs/theme/app_colors.dart';

void showCustomSnackbar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

class ResetPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ResetPassword({super.key});

  void resetPassword(BuildContext context) async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      showCustomSnackbar(context, "Please enter your email", Colors.red);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showCustomSnackbar(
          context, "Password Reset email was sent to your email", Colors.green);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.code == 'user-not-found') {
        errorMessage = "Email not registered";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Enter a valid email address";
      }

      showCustomSnackbar(context, errorMessage, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customAppBar(title: "Reset password"),
                  SizedBox(height: 20.h),
                  Text("Email address"),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Enter your email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
              SizedBox(
                  height: 70.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => resetPassword(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                    ),
                    child: Text("Send reset link"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
