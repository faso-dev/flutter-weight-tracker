import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

class GardeMonPoidsApp extends StatelessWidget {
  final AuthService authService;

  const GardeMonPoidsApp({Key? key, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GardeMonPoids',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Respects the device's theme settings
      home: FutureBuilder<bool>(
        future: authService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            if (snapshot.data == true) {
              return HomeScreen(authService: authService);
            } else {
              return LoginScreen(authService: authService);
            }
          }
        },
      ),
    );
  }
}
