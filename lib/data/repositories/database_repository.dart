abstract class DatabaseRepository {
  Future<void> overrideRecentTemperature(double recentTemp);
  Future<double> get recentTemperature;
  Future<void> clearHistory();
  Future<void> overrideRecentCity(String currentCity);
  Future<String> get recentCity;
}
