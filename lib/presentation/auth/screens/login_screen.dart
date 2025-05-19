import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task/core/routes/routes.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../blocs/signin_bloc/sign_in_bloc.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false; // Hide&Show password

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Enter your email";
    }
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Enter your password";
    }
    if (value.length < 6) {
      return "password must be at least 6 characters";
    }
    return null;
  }

  void _onSignIn(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      context
          .read<SignInBloc>()
          .add(SignInRequested(email: email, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 50.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome!",
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  SizedBox(height: 30.h),

                  // Email Field
                  Text("Email"),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "your email",
                    ),
                    validator: (value) => validateEmail(value ?? ""),
                  ),
                  SizedBox(height: 20.h),

                  // Password Field
                  Text("Password"),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "your password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) => validatePassword(value ?? ""),
                  ),

                  SizedBox(height: 5.h),

                  // Error Message
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) {
                      if (state is SignInError) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            state.message,
                            style: TextStyle(color: Colors.red[900]),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),

                  SizedBox(height: 5.h),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/reset');
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                    ),
                  ),

                  // Sign In Button
                  BlocConsumer<SignInBloc, SignInState>(
                    listener: (context, state) {
                      if (state is SignInSuccess) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('تم تسجيل الدخول بنجاح!')),
                        // );
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RouteNames.root, (route) => false);
                      } else if (state is SignInError) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('فشل تسجيل الدخول: ')),
                        // );
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        height: 70.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is SignInLoading
                              ? null
                              : () => _onSignIn(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                          ),
                          child: state is SignInLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  "LogIn",
                                  style: TextStyle(fontSize: 20),
                                ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text("Or with"),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Google Sign In
                  GestureDetector(
                    onTap: () {
                      context.read<SignInBloc>().add(GoogleSignInRequested());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 70.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.grey),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 25.h, horizontal: 50.w),
                        child: Image.asset("assets/images/google.png"),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RouteNames.signUp);
                        },
                        child: Text("Sign Up"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
