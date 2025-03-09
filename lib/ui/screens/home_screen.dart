import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p21_weather_app/data/api_urls.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';

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
  String _timeInfoText = "";
  String _preciptationInfoText = "";
  String _rainInfoText = "";
  String _humidityInfoText = "";
  String _apparentTempInfoText = "";
  double? _mostRecentTemperature = 0.0;
  double? _mostRecentApparentTemp = 0.0;
  int? _mostRecentHumidity = 0;
  double? _mostRecentRain = 0.0;
  TextEditingController cityController = TextEditingController();
  String _currentCity = "Berlin";

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
    _currentCity = await widget.sharedPrefsRepo.recentCity;
    _mostRecentTemperature = await widget.sharedPrefsRepo.recentTemperature;
    _mostRecentApparentTemp = await widget.sharedPrefsRepo.recentApparentTemp;

    setState(() {
      if (_currentCity.isEmpty) {
        _currentCity = "Berlin";
      }

      if (_mostRecentTemperature == null) {
        _tempInfoText = "Aktuell keine Daten vorhanden";
      } else {
        _tempInfoText =
            "Temperatur in $_currentCity: $_mostRecentTemperature °C";
      }

      if (_mostRecentApparentTemp != null) {
        _apparentTempInfoText = "Gefühlt: $_mostRecentApparentTemp °C";
      }
      if (_mostRecentHumidity != null) {
        _humidityInfoText = "Luftfeuchtigkeit: $_mostRecentHumidity%";
      }
      if (_mostRecentRain != null) {
        _rainInfoText = "Regenwahrscheinlichkeit: $_mostRecentRain%";
      }
    });
  }

  void fetchCurrentWeatherData(currentCity) async {
    String? uri = apiUris[currentCity];
    if (uri == null) return;
    final response = await http.get(Uri.parse(uri));

    final weatherJsonData = jsonDecode(response.body);
    final newTemperature = weatherJsonData["current"]["temperature_2m"];
    final newHumidity = weatherJsonData["current"]["relative_humidity_2m"];
    final newApparentTemp = weatherJsonData["current"]["apparent_temperature"];
    final newRain = weatherJsonData["current"]["rain"];

    setState(() {
      _tempInfoText = "Temperatur in $currentCity: $newTemperature °C";
      _apparentTempInfoText = "Gefühlt: $newApparentTemp °C";
      _humidityInfoText = "Luftfeuchtigkeit: $newHumidity%";
      _rainInfoText = "Regenwahrscheinlichkeit: $newRain%";
    });
    await widget.sharedPrefsRepo.overrideRecentTemperature(newTemperature);
    await widget.sharedPrefsRepo.overrideRecentApparentTemp(newApparentTemp);
    await widget.sharedPrefsRepo.overrideRecentHumidity(newHumidity);
    await widget.sharedPrefsRepo.overrideRecentRain(newRain);
    _currentCity = currentCity!;
    await widget.sharedPrefsRepo.overrideRecentCity(currentCity);
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
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              _currentCity,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
            ),
            Text(_tempInfoText, style: TextStyle(fontSize: 20)),
            Text(_apparentTempInfoText, style: TextStyle(fontSize: 20)),
            Text(_humidityInfoText, style: TextStyle(fontSize: 20)),
            Text(_rainInfoText, style: TextStyle(fontSize: 20)),
            Spacer(),
            ElevatedButton.icon(
              label: Text("Aktualisieren"),
              icon: Icon(
                Icons.refresh,
                size: 40,
              ),
              onPressed: () {
                fetchCurrentWeatherData(_currentCity);
              },
            ),
            DropdownMenu(
              initialSelection: _currentCity,
              controller: cityController,
              onSelected: (value) {
                setState(() {
                  _currentCity = value!;
                });
              },
              dropdownMenuEntries: apiUris.keys
                  .map((city) => DropdownMenuEntry(value: city, label: city))
                  .toList(),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
