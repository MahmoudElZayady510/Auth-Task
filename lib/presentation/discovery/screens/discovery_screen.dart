import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../auth/blocs/signout_bloc/signout_bloc.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discovery',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.explore,
                size: 80.r,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 20.h),
              Text(
                'Welcome to the Discovery Screen!',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              BlocListener<SignoutBloc, SignoutState>(
                listener: (context, state) {
                  if (state is SignoutSuccess) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/signin',
                          (Route<dynamic> route) => false,
                    );
                  }
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  onTap: () async {
                    bool? result = await showLogoutConfirmationDialog(context);
                    if (result == true) {
                      context.read<SignoutBloc>().add(SignOutRequested());
                    }
                  },
                  tileColor: AppColors.primaryColor.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.r,
                    color: AppColors.text,
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


Future<bool?> showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // User must tap a button
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm LogOut"),
        content: Text("Are you sure you want to log out?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Return false
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Return true
            child: Text("LogOut"),
          ),
        ],
      );
    },
  );
}
