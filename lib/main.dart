import 'package:flutter/material.dart';
import 'app.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  await authService.loadUser();
  runApp(GardeMonPoidsApp(authService: authService));
}
