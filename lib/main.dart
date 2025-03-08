import 'package:flutter/material.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';
import 'package:p21_weather_app/main_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferencesRepository sharedPrefsRepo =
      SharedPreferencesRepository();
  runApp(MainApp(sharedPrefsRepo: sharedPrefsRepo));
}
