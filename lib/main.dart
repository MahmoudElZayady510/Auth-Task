import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task/presentation/auth/blocs/signin_bloc/sign_in_bloc.dart';
import 'package:task/presentation/auth/blocs/signout_bloc/signout_bloc.dart';
import 'package:task/presentation/auth/blocs/signup_bloc/sign_up_bloc.dart';
import 'package:task/presentation/auth/screens/signup_screen.dart';
import 'core/configs/theme/app_theme.dart';
import 'core/routes/route_generator.dart';
import 'data/auth/repository/auth_repository.dart';
import 'domain/auth/use_cases/logout_user.dart';
import 'domain/auth/use_cases/register_user.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (_) => sl<AuthRepository>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SignInBloc(authRepository: sl<AuthRepository>())),
          BlocProvider(create: (_) => SignUpBloc(sl<SignUpUseCase>(), sl<AuthRepository>())),
          BlocProvider(create: (_) => SignoutBloc(sl<LogoutUserUsecase>())),
        ],
        child: ScreenUtilInit(
            designSize: Size(411, 866),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'Auth Task',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.appTheme,
                onGenerateRoute: RouteGenerator.generateRoute,
                initialRoute: '/',
              );
            }),
      ),
    );
  }
}
