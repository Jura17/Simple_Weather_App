abstract class DatabaseRepository {
  Future<void> overrideRecentCity(String currentCity);
  Future<void> overrideRecentTemperature(double recentTemp);
  Future<void> overrideRecentApparentTemp(double recentApparentTemp);
  Future<void> overrideRecentHumidity(int recentHumidity);
  Future<void> overrideRecentRainSum(double recentRainSumList);
  Future<void> overrideMinTempList(List<dynamic> recentMinTempList);
  Future<void> overrideMaxTempList(List<dynamic> recentMaxTempList);
  Future<void> overrideDateList(List<dynamic> recentDateList);

  Future<String> get recentCity;
  Future<double?> get recentTemperature;
  Future<double?> get recentApparentTemp;
  Future<int?> get recentHumidity;
  Future<double?> get recentRainSum;
  Future<List<String>?> get recentMinTempList;
  Future<List<String>?> get recentMaxTempList;
  Future<List<String>?> get recentDateList;
  Future<void> clearHistory();
}
