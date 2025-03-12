import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p21_weather_app/data/city_data.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';
import 'package:p21_weather_app/ui/widgets/apparent_temperature.dart';
import 'package:p21_weather_app/ui/widgets/high_low_temperatures.dart';
import 'package:p21_weather_app/ui/widgets/humidity.dart';
import 'package:p21_weather_app/ui/widgets/seven_day_forecast_container.dart';

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
  String _rainSumInfoText = "";
  String _messageText = "";
  bool _showMessage = false;
  double? _savedTemperature;
  double? _savedRainSum;
  String _savedCity = "Berlin";

  dynamic _weatherJsonData = "";
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
    _savedTemperature = await widget.sharedPrefsRepo.savedTemperature;
    _savedRainSum = await widget.sharedPrefsRepo.savedRainSum;
    _savedCity = await widget.sharedPrefsRepo.savedCity;

    setState(() {
      if (_savedCity.isEmpty) {
        _savedCity = "Berlin";
      }

      if (_savedTemperature == null) {
        _showMessage = true;
        _messageText = "Aktuell keine Daten vorhanden";
      } else {
        _tempInfoText = "$_savedTemperature °C";
      }
      if (_savedRainSum != null) {
        _rainSumInfoText = "Regenmenge heute: $_savedRainSum mm";
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
        _weatherJsonData = jsonDecode(response.body);
        processWeatherData(_weatherJsonData, currentCity);
      } else {
        setState(() {
          _showMessage = true;
          _messageText =
              "Daten konnten nicht geladen werden.\nVersuch es später erneut.";
        });
      }
    } catch (error) {
      setState(() {
        _showMessage = true;
        _messageText = "Ein Fehler ist aufgetreten";
      });
      return;
    }
  }

  void processWeatherData(weatherJsonData, currentCity) async {
    try {
      final newTemperature = weatherJsonData["current"]["temperature_2m"];
      final newRainSumList = weatherJsonData["daily"]["rain_sum"];

      setState(() {
        _showMessage = false;
        _tempInfoText = "$newTemperature °C";
        _rainSumInfoText = "Regenmenge heute: ${newRainSumList.first} mm";
        _messageText = "";
      });
      await widget.sharedPrefsRepo.overrideSavedTemperature(newTemperature);
      await widget.sharedPrefsRepo.overrideSavedRainSum(newRainSumList.first);

      _savedCity = currentCity!;
      await widget.sharedPrefsRepo.overrideSavedCity(currentCity);
    } catch (error) {
      _showMessage = true;
      _messageText = "Es ist ein Problem aufgetreten";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.sharedPrefsRepo.clearHistory();
                _showMessage = true;
                _messageText = "Aktuell keine Daten vorhanden";
              });
            },
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
              SizedBox(height: 70),
              Text(
                _savedCity,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20),
              _showMessage
                  ? Text(_messageText, style: TextStyle(fontSize: 20))
                  : SizedBox(
                      child: Column(
                        children: [
                          Text(_tempInfoText, style: TextStyle(fontSize: 40)),
                          ApparentTemperature(
                            weatherJsonData: _weatherJsonData,
                            sharedPrefsRepo: widget.sharedPrefsRepo,
                          ),
                          HighLowTemperatures(
                              weatherJsonData: _weatherJsonData,
                              sharedPrefsRepo: widget.sharedPrefsRepo),
                          SizedBox(height: 30),
                          Humidity(
                              sharedPrefsRepo: widget.sharedPrefsRepo,
                              weatherJsonData: _weatherJsonData),
                          SizedBox(height: 5),
                          Text(_rainSumInfoText,
                              style: TextStyle(fontSize: 20)),
                          SizedBox(height: 40),
                          SevenDayForecastContainer(
                            weatherJsonData: _weatherJsonData,
                            sharedPrefsRepo: widget.sharedPrefsRepo,
                          )
                        ],
                      ),
                    ),
              Spacer(),
              Column(
                children: [
                  DropdownMenu(
                    initialSelection: _savedCity,
                    controller: cityController,
                    onSelected: (value) {
                      setState(() {
                        _savedCity = value!;
                        fetchCurrentWeatherData(_savedCity);
                      });
                    },
                    dropdownMenuEntries: cityData.keys
                        .map((city) =>
                            DropdownMenuEntry(value: city, label: city))
                        .toList(),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton.icon(
                    label: Text("Aktualisieren"),
                    icon: Icon(
                      Icons.refresh,
                      size: 40,
                    ),
                    onPressed: () {
                      fetchCurrentWeatherData(_savedCity);
                    },
                  ),
                ],
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
