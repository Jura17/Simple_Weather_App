import 'package:p21_weather_app/data/repositories/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository extends DatabaseRepository {
  final String _tempKey = "recentTemperature";
  final String _cityKey = "recentCity";
  final String _apparentTempKey = "recentApparentTemp";
  final String _humidityKey = "recentHumidity";
  final String _rainSumKey = "recentRainSum";
  final String _minTempKey = "minTempList";
  final String _maxTempKey = "maxTempList";

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
  Future<void> overrideRecentRainSum(double recentRainSum) async {
    final prefs = await _prefsFuture;

    await prefs.setDouble(_rainSumKey, recentRainSum);
  }

  @override
  Future<void> overrideMinTempList(List<dynamic> recentMinTempList) async {
    final prefs = await _prefsFuture;
    final List<String> minTempStringList =
        recentMinTempList.map((minTemp) => minTemp.toString()).toList();

    await prefs.setStringList(_minTempKey, minTempStringList);
  }

  @override
  Future<void> overrideMaxTempList(List<dynamic> recentMaxTempList) async {
    final prefs = await _prefsFuture;
    final List<String> maxTempStringList =
        recentMaxTempList.map((maxTemp) => maxTemp.toString()).toList();

    await prefs.setStringList(_maxTempKey, maxTempStringList);
  }

  @override
  Future<void> clearHistory() async {
    final prefs = await _prefsFuture;
    prefs.remove(_tempKey);
    prefs.remove(_apparentTempKey);
    prefs.remove(_humidityKey);
    prefs.remove(_rainSumKey);
    prefs.remove(_minTempKey);
    prefs.remove(_maxTempKey);
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
  Future<double?> get recentRainSum async {
    final prefs = await _prefsFuture;
    return prefs.getDouble(_rainSumKey);
  }

  @override
  Future<List<String>?> get recentMinTempList async {
    final prefs = await _prefsFuture;
    return prefs.getStringList(_minTempKey);
  }

  @override
  Future<List<String>?> get recentMaxTempList async {
    final prefs = await _prefsFuture;
    return prefs.getStringList(_maxTempKey);
  }
}
