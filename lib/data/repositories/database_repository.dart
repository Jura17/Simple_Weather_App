abstract class DatabaseRepository {
  Future<void> overrideSavedCity(String newCity);
  Future<void> overrideSavedTemperature(double newTemp);
  Future<void> overrideSavedApparentTemp(double newApparentTemp);
  Future<void> overrideSavedHumidity(int newHumidity);
  Future<void> overrideSavedRainSum(double newRainSum);
  Future<void> overrideSavedMinTempList(List<dynamic> newMinTempList);
  Future<void> overrideSavedMaxTempList(List<dynamic> newMaxTempList);
  Future<void> overrideSavedDateList(List<dynamic> newDateList);

  Future<String> get savedCity;
  Future<double?> get savedTemperature;
  Future<double?> get savedApparentTemp;
  Future<int?> get savedHumidity;
  Future<double?> get savedRainSum;
  Future<List<String>?> get savedMinTempList;
  Future<List<String>?> get savedMaxTempList;
  Future<List<String>?> get savedDateList;
  Future<void> clearHistory();
}
