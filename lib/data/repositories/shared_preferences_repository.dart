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
  final String _dateListKey = "dateList";

  late final Future<SharedPreferences> _prefsFuture;

  SharedPreferencesRepository() {
    _prefsFuture = SharedPreferences.getInstance();
  }

  @override
  Future<void> overrideSavedTemperature(double newTemp) async {
    final prefs = await _prefsFuture;
    await prefs.setDouble(_tempKey, newTemp);
  }

  @override
  Future<void> overrideSavedApparentTemp(double newApparentTemp) async {
    final prefs = await _prefsFuture;
    await prefs.setDouble(_apparentTempKey, newApparentTemp);
  }

  @override
  Future<void> overrideSavedHumidity(int newHumidity) async {
    final prefs = await _prefsFuture;
    await prefs.setInt(_humidityKey, newHumidity);
  }

  @override
  Future<void> overrideSavedRainSum(double newRainSum) async {
    final prefs = await _prefsFuture;

    await prefs.setDouble(_rainSumKey, newRainSum);
  }

  @override
  Future<void> overrideSavedMinTempList(List<dynamic> newMinTempList) async {
    final prefs = await _prefsFuture;
    final List<String> minTempStringList =
        newMinTempList.map((minTemp) => minTemp.toString()).toList();

    await prefs.setStringList(_minTempKey, minTempStringList);
  }

  @override
  Future<void> overrideSavedMaxTempList(List<dynamic> newMaxTempList) async {
    final prefs = await _prefsFuture;
    final List<String> maxTempStringList =
        newMaxTempList.map((maxTemp) => maxTemp.toString()).toList();

    await prefs.setStringList(_maxTempKey, maxTempStringList);
  }

  @override
  Future<void> overrideSavedCity(String newCity) async {
    final prefs = await _prefsFuture;
    await prefs.setString(_cityKey, newCity);
  }

  @override
  Future<void> overrideSavedDateList(List<dynamic> newDateList) async {
    final prefs = await _prefsFuture;
    final List<String> dateStringList =
        newDateList.map((date) => date.toString()).toList();
    await prefs.setStringList(_dateListKey, dateStringList);
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
    prefs.remove(_dateListKey);
  }

  @override
  Future<String> get savedCity async {
    final prefs = await _prefsFuture;
    return prefs.getString(_cityKey) ?? '';
  }

  @override
  Future<double?> get savedTemperature async {
    final prefs = await _prefsFuture;
    return prefs.getDouble(_tempKey);
  }

  @override
  Future<double?> get savedApparentTemp async {
    final prefs = await _prefsFuture;
    return prefs.getDouble(_apparentTempKey);
  }

  @override
  Future<int?> get savedHumidity async {
    final prefs = await _prefsFuture;
    return prefs.getInt(_humidityKey);
  }

  @override
  Future<double?> get savedRainSum async {
    final prefs = await _prefsFuture;
    return prefs.getDouble(_rainSumKey);
  }

  @override
  Future<List<String>?> get savedMinTempList async {
    final prefs = await _prefsFuture;
    return prefs.getStringList(_minTempKey);
  }

  @override
  Future<List<String>?> get savedMaxTempList async {
    final prefs = await _prefsFuture;
    return prefs.getStringList(_maxTempKey);
  }

  @override
  Future<List<String>?> get savedDateList async {
    final prefs = await _prefsFuture;
    return prefs.getStringList(_dateListKey);
  }
}
