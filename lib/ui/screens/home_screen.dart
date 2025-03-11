import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p21_weather_app/data/city_data.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';
import 'package:p21_weather_app/ui/widgets/weather_data_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.sharedPrefsRepo,
  });

  final SharedPreferencesRepository sharedPrefsRepo;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _tempInfoText = "";
  String _apparentTempInfoText = "";
  String _humidityInfoText = "";
  String _rainSumInfoText = "";
  String _minTempTodayInfoText = "";
  String _maxTempTodayInfoText = "";
  String _errorText = "";
  bool _showError = false;
  final Map<String, dynamic> _foreCastData = {};

  double? _mostRecentTemperature;
  double? _mostRecentApparentTemp;
  int? _mostRecentHumidity;
  double? _mostRecentRainSum;
  List<String>? _mostRecentMinTempList;
  List<String>? _mostRecentMaxTempList;
  List<String>? _mostRecentDateList;
  String _mostRecentCity = "Berlin";

  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecentWeatherData();
  }

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
  }

  void fetchRecentWeatherData() async {
    _mostRecentTemperature = await widget.sharedPrefsRepo.recentTemperature;
    _mostRecentMinTempList = await widget.sharedPrefsRepo.recentMinTempList;
    _mostRecentMaxTempList = await widget.sharedPrefsRepo.recentMaxTempList;
    _mostRecentApparentTemp = await widget.sharedPrefsRepo.recentApparentTemp;
    _mostRecentHumidity = await widget.sharedPrefsRepo.recentHumidity;
    _mostRecentRainSum = await widget.sharedPrefsRepo.recentRainSum;
    _mostRecentCity = await widget.sharedPrefsRepo.recentCity;
    _mostRecentDateList = await widget.sharedPrefsRepo.recentDateList;

    setState(() {
      if (_mostRecentCity.isEmpty) {
        _mostRecentCity = "Berlin";
      }

      if (_mostRecentTemperature == null) {
        _showError = true;
        _errorText = "Aktuell keine Daten vorhanden";
      } else {
        _tempInfoText = "$_mostRecentTemperature °C";
      }

      if (_mostRecentApparentTemp != null) {
        _apparentTempInfoText = "Gefühlt: $_mostRecentApparentTemp °C";
      }
      if (_mostRecentHumidity != null) {
        _humidityInfoText = "Luftfeuchtigkeit: $_mostRecentHumidity%";
      }
      if (_mostRecentRainSum != null) {
        _rainSumInfoText = "Regenmenge heute: $_mostRecentRainSum mm";
      }
      if (_mostRecentMinTempList != null && _mostRecentMaxTempList != null) {
        _minTempTodayInfoText = "L: ${_mostRecentMinTempList!.first}";
        _maxTempTodayInfoText = "H: ${_mostRecentMaxTempList!.first}";
      }
      if (_mostRecentMinTempList != null &&
          _mostRecentMaxTempList != null &&
          _mostRecentDateList != null) {
        generateForecastMap(_mostRecentDateList, _mostRecentMinTempList,
            _mostRecentMaxTempList);
      }
    });
  }

  void fetchCurrentWeatherData(currentCity) async {
    final double latitude;
    final double longitude;

    (latitude, longitude) = cityData[currentCity];
    final String uri =
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,apparent_temperature&daily=temperature_2m_max,temperature_2m_min,rain_sum";

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final weatherJsonData = jsonDecode(response.body);
        processWeatherData(weatherJsonData, currentCity);
      } else {
        setState(() {
          _showError = true;
          _errorText =
              "Daten konnten nicht geladen werden.\nVersuch es später erneut.";
        });
      }
    } catch (error) {
      setState(() {
        _showError = true;
        _errorText = "Ein Fehler ist aufgetreten";
      });
      return;
    }
  }

  void generateForecastMap(dateList, minTempList, maxTempList) {
    List<String> weekDays = [
      "Montag",
      "Dienstag",
      "Mittwoch",
      "Donnerstag",
      "Freitag",
      "Samstag",
      "Sonntag"
    ];

    for (int i = 0; i < dateList.length; i++) {
      DateTime date = DateTime.parse(dateList[i]);
      String weekDay = weekDays[date.weekday - 1];
      _foreCastData[weekDay] = [minTempList[i], maxTempList[i]];
    }
  }

  void processWeatherData(weatherJsonData, currentCity) async {
    try {
      final newTemperature = weatherJsonData["current"]["temperature_2m"];
      final newHumidity = weatherJsonData["current"]["relative_humidity_2m"];
      final newApparentTemp =
          weatherJsonData["current"]["apparent_temperature"];
      final newRainSumList = weatherJsonData["daily"]["rain_sum"];
      final newMinTempList = weatherJsonData["daily"]["temperature_2m_min"];
      final newMaxTempList = weatherJsonData["daily"]["temperature_2m_max"];

      final newDateList = weatherJsonData["daily"]["time"];
      generateForecastMap(newDateList, newMinTempList, newMaxTempList);

      setState(() {
        _showError = false;
        _tempInfoText = "$newTemperature °C";
        _apparentTempInfoText = "Gefühlt: $newApparentTemp °C";
        _humidityInfoText = "Luftfeuchtigkeit: $newHumidity%";
        _rainSumInfoText = "Regenmenge heute: ${newRainSumList.first} mm";
        _minTempTodayInfoText = "L: ${newMinTempList.first}";
        _maxTempTodayInfoText = "H: ${newMaxTempList.first}";
        _errorText = "";
      });
      await widget.sharedPrefsRepo.overrideRecentTemperature(newTemperature);
      await widget.sharedPrefsRepo.overrideRecentApparentTemp(newApparentTemp);
      await widget.sharedPrefsRepo.overrideRecentHumidity(newHumidity);
      await widget.sharedPrefsRepo.overrideRecentRainSum(newRainSumList.first);
      await widget.sharedPrefsRepo.overrideMinTempList(newMinTempList);
      await widget.sharedPrefsRepo.overrideMaxTempList(newMaxTempList);
      await widget.sharedPrefsRepo.overrideDateList(newDateList);

      _mostRecentCity = currentCity!;
      await widget.sharedPrefsRepo.overrideRecentCity(currentCity);
    } catch (error) {
      _showError = true;
      _errorText = "Es ist ein Problem aufgetreten";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: widget.sharedPrefsRepo.clearHistory,
            child: Text("Historie löschen"),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                _mostRecentCity,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20),
              _showError
                  ? Text(_errorText, style: TextStyle(fontSize: 20))
                  : WeatherDataContainer(
                      tempInfoText: _tempInfoText,
                      apparentTempInfoText: _apparentTempInfoText,
                      minTempTodayInfoText: _minTempTodayInfoText,
                      maxTempTodayInfoText: _maxTempTodayInfoText,
                      humidityInfoText: _humidityInfoText,
                      rainSumInfoText: _rainSumInfoText,
                      foreCastData: _foreCastData,
                    ),
              Spacer(),
              Column(
                children: [
                  DropdownMenu(
                    initialSelection: _mostRecentCity,
                    controller: cityController,
                    onSelected: (value) {
                      setState(() {
                        _mostRecentCity = value!;
                      });
                    },
                    dropdownMenuEntries: cityData.keys
                        .map((city) =>
                            DropdownMenuEntry(value: city, label: city))
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    label: Text("Aktualisieren"),
                    icon: Icon(
                      Icons.refresh,
                      size: 40,
                    ),
                    onPressed: () {
                      fetchCurrentWeatherData(_mostRecentCity);
                    },
                  ),
                ],
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
