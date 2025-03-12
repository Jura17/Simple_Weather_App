import 'package:flutter/material.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';

class Temperature extends StatefulWidget {
  const Temperature({
    super.key,
    required this.weatherJsonData,
    required this.sharedPrefsRepo,
  });

  final dynamic weatherJsonData;
  final SharedPreferencesRepository sharedPrefsRepo;

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  String _temperatureInfoText = "";
  double? _savedTemperature;

  @override
  void initState() {
    super.initState();
    fetchRecentTemperatureData();
  }

  @override
  Widget build(BuildContext context) {
    processTemperatureData(widget.weatherJsonData);
    return Text(_temperatureInfoText, style: TextStyle(fontSize: 40));
  }

  void fetchRecentTemperatureData() async {
    _savedTemperature = await widget.sharedPrefsRepo.savedTemperature;
    setState(() {
      if (_savedTemperature != null) {
        _temperatureInfoText = "$_savedTemperature °C";
      }
    });
  }

  void processTemperatureData(weatherJsonData) async {
    if (weatherJsonData == null || weatherJsonData == "") return;
    final newTemperature = weatherJsonData["current"]["temperature_2m"];
    setState(() {
      _temperatureInfoText = "$newTemperature °C";
    });
    await widget.sharedPrefsRepo.overrideSavedTemperature(newTemperature);
  }
}
