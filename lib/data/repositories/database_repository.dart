abstract class DatabaseRepository {
  Future<void> overrideRecentCity(String currentCity);
  Future<void> overrideRecentTemperature(double recentTemp);
  Future<void> overrideRecentApparentTemp(double recentApparentTemp);
  Future<void> overrideRecentHumidity(int recentHumidity);
  Future<void> overrideRecentPrecipitation(double recentPrecipitation);
  Future<void> overrideRecentRain(double recentRain);
  Future<String> get recentCity;
  Future<double?> get recentTemperature;
  Future<double?> get recentApparentTemp;
  Future<int?> get recentHumidity;
  Future<double?> get recentPricipitation;
  Future<double?> get recentRain;
  Future<void> clearHistory();
}
