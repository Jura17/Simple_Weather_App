import 'package:flutter/material.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';

import 'package:p21_weather_app/ui/screens/home_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.sharedPrefsRepo,
  });

  final SharedPreferencesRepository sharedPrefsRepo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen(sharedPrefsRepo: sharedPrefsRepo));
  }
}
