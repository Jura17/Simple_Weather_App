import 'package:p21_weather_app/data/repositories/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository extends DatabaseRepository {
  final String _tempKey = "recentTemperature";
  final String _cityKey = "recentCity";
  final String _apparentTempKey = "recentApparentTemp";
  final String _humidityKey = "recentHumidity";
  final String _precipitationKey = "recentPrecipitation";
  final String _rainKey = "recentRain";

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
  Future<void> overrideRecentApparentTemp(double recentApparentTemp) async {
    final prefs = await _prefsFuture;
    await prefs.setDouble(_apparentTempKey, recentApparentTemp);
  }

  @override
  Future<void> overrideRecentHumidity(int recentHumidity) async {
    final prefs = await _prefsFuture;
    await prefs.setInt(_humidityKey, recentHumidity);
  }

  @override
  Future<void> overrideRecentPrecipitation(double recentPrecipitation) async {
    final prefs = await _prefsFuture;
    await prefs.setDouble(_precipitationKey, recentPrecipitation);
  }

  @override
  Future<void> overrideRecentRain(double recentRain) async {
    final prefs = await _prefsFuture;
    await prefs.setDouble(_rainKey, recentRain);
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

  @override
  Future<double?> get recentTemperature async {
    final prefs = await _prefsFuture;
    return prefs.getDouble(_tempKey);
  }

  @override
  Future<double?> get recentApparentTemp async {
    final prefs = await _prefsFuture;
    return prefs.getDouble(_apparentTempKey);
  }

  @override
  Future<int?> get recentHumidity async {
    final prefs = await _prefsFuture;
    return prefs.getInt(_humidityKey);
  }

  @override
  Future<double?> get recentPricipitation async {
    final prefs = await _prefsFuture;
    return prefs.getDouble(_precipitationKey);
  }

  @override
  Future<double?> get recentRain async {
    final prefs = await _prefsFuture;
    return prefs.getDouble(_rainKey);
  }
}
