import 'package:p21_weather_app/data/repositories/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository extends DatabaseRepository {
  final String _tempKey = "recentTemperature";
  final String _cityKey = "recentCity";

  late final Future<SharedPreferences> _prefsFuture;

  SharedPreferencesRepository() {
    _prefsFuture = SharedPreferences.getInstance();
  }

  @override
  Future<void> overrideRecentTemperature(double recentTemp) async {
    final prefs = await _prefsFuture;
    await prefs.setDouble(_tempKey, recentTemp);
  }

  @override
  Future<double> get recentTemperature async {
    final prefs = await _prefsFuture;
    return prefs.getDouble(_tempKey) ?? 0.0;
  }

  @override
  Future<void> clearHistory() async {
    final prefs = await _prefsFuture;
    prefs.remove(_tempKey);
  }

  @override
  Future<void> overrideRecentCity(String currentCity) async {
    final prefs = await _prefsFuture;
    await prefs.setString(_cityKey, currentCity);
  }

  @override
  Future<String> get recentCity async {
    final prefs = await _prefsFuture;
    return prefs.getString(_cityKey) ?? '';
  }
}
