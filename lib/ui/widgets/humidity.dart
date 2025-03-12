import 'package:flutter/material.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';

class Humidity extends StatefulWidget {
  const Humidity({
    super.key,
    required this.sharedPrefsRepo,
    required this.weatherJsonData,
  });

  final SharedPreferencesRepository sharedPrefsRepo;
  final dynamic weatherJsonData;

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
  String _humidityInfoText = "";
  int? _savedHumidity;

  @override
  void initState() {
    super.initState();
    fetchSavedHumidityData();
  }

  @override
  Widget build(BuildContext context) {
    processHumidityData(widget.weatherJsonData);
    return Text(_humidityInfoText, style: TextStyle(fontSize: 20));
  }

  void fetchSavedHumidityData() async {
    _savedHumidity = await widget.sharedPrefsRepo.savedHumidity;

    setState(() {
      if (_savedHumidity != null) {
        _humidityInfoText = "Luftfeuchtigkeit: $_savedHumidity%";
      }
    });
  }

  void processHumidityData(weatherJsonData) async {
    if (weatherJsonData == null || weatherJsonData == "") return;
    final newHumidity = weatherJsonData["current"]["relative_humidity_2m"];
    setState(() {
      _humidityInfoText = "Luftfeuchtigkeit: $newHumidity%";
    });
    await widget.sharedPrefsRepo.overrideSavedHumidity(newHumidity);
  }
}
