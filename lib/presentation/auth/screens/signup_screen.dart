import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task/core/routes/routes.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../blocs/signup_bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isPasswordVisible = false;
  bool isSubmitted = false;

  String? validateEmail(String value) {
    if (value.isEmpty) return "Enter your email";
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(value)) return "Enter a valid email";
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return "Enter your password";
    if (value.length < 6) return "password must be at least 6 characters";
    return null;
  }

  String? validateFirstName(String value) {
    if (value.isEmpty) return "Enter your first name";
    return null;
  }

  void submitForm() {
    setState(() {
      isSubmitted = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final address = addressController.text.trim();

    if (validateEmail(email) == null &&
        validatePassword(password) == null &&
        validateFirstName(firstName) == null) {
      context
          .read<SignUpBloc>()
          .add(SignUpRequested(email, password, firstName, lastName, address));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 50.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome!",
                      style: TextStyle(fontSize: 24.sp),
                    ),
                    SizedBox(height: 30.h),

                    // Full Name
                    Text("Your full name"),
                    SizedBox(height: 5.h),
                    TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        errorText: isSubmitted
                            ? validateFirstName(firstNameController.text)
                            : null,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Email
                    Text("Email"),
                    SizedBox(height: 5.h),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        errorText: isSubmitted
                            ? validateEmail(emailController.text)
                            : null,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Password
                    Text("Password"),
                    SizedBox(height: 5.h),
                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        errorText: isSubmitted
                            ? validatePassword(passwordController.text)
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    BlocBuilder<SignUpBloc, SignUpState>(
                      builder: (context, state) {
                        if (state is SignUpFailure) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "Something went wrong",
                              style: TextStyle(color: Colors.red[900]),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<SignUpBloc, SignUpState>(
                    listener: (context, state) {
                      if (state is SignUpSuccess) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('تم التسجيل بنجاح!')),
                        // );
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RouteNames.root, (route) => false);
                      } else if (state is SignUpFailure) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('فشل التسجيل: ${state.error}')),
                        // );
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        height: 70.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is SignUpLoading ? null : submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                          ),
                          child: state is SignUpLoading
                              ? CircularProgressIndicator()
                              : Text("Sign Up"),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text("Or With"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    context.read<SignUpBloc>().add(GoogleSignUpRequested());
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.signIn);
                      },
                      child: Text("Sign In"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
