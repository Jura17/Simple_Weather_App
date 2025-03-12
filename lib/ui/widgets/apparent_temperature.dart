import 'package:flutter/material.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';

class ApparentTemperature extends StatefulWidget {
  const ApparentTemperature({
    super.key,
    required this.sharedPrefsRepo,
    required this.weatherJsonData,
  });

  final SharedPreferencesRepository sharedPrefsRepo;
  final dynamic weatherJsonData;

  @override
  State<ApparentTemperature> createState() => _ApparentTemperatureState();
}

class _ApparentTemperatureState extends State<ApparentTemperature> {
  String _apparentTempInfoText = "";
  double? _savedApparentTemp;

  @override
  void initState() {
    super.initState();
    fetchSavedApparentTemperature();
  }

  @override
  Widget build(BuildContext context) {
    processApparentTempData(widget.weatherJsonData);
    return Text(_apparentTempInfoText, style: TextStyle(fontSize: 20));
  }

  void fetchSavedApparentTemperature() async {
    _savedApparentTemp = await widget.sharedPrefsRepo.savedApparentTemp;

    setState(() {
      if (_savedApparentTemp != null) {
        _apparentTempInfoText = "Gefühlt: $_savedApparentTemp °C";
      }
    });
  }

  void processApparentTempData(weatherJsonData) async {
    if (weatherJsonData == null || weatherJsonData == "") return;
    final newApparentTemp = weatherJsonData["current"]["apparent_temperature"];

    setState(() {
      _apparentTempInfoText = "Gefühlt: $newApparentTemp °C";
    });
    await widget.sharedPrefsRepo.overrideSavedApparentTemp(newApparentTemp);
  }
}
