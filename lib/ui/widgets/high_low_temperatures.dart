import 'package:flutter/material.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';

class HighLowTemperatures extends StatefulWidget {
  const HighLowTemperatures({
    super.key,
    required this.sharedPrefsRepo,
    required this.weatherJsonData,
  });

  final SharedPreferencesRepository sharedPrefsRepo;
  final dynamic weatherJsonData;

  @override
  State<HighLowTemperatures> createState() => _HighLowTemperaturesState();
}

class _HighLowTemperaturesState extends State<HighLowTemperatures> {
  String _minTempTodayInfoText = "";
  String _maxTempTodayInfoText = "";
  List<String>? _savedMinTempList;
  List<String>? _savedMaxTempList;

  @override
  void initState() {
    super.initState();
    fetchSavedHighLowTemperatures();
  }

  @override
  Widget build(BuildContext context) {
    processHighLowTempData(widget.weatherJsonData);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Text(_minTempTodayInfoText, style: TextStyle(fontSize: 20)),
        Text(_maxTempTodayInfoText, style: TextStyle(fontSize: 20)),
      ],
    );
  }

  void fetchSavedHighLowTemperatures() async {
    _savedMinTempList = await widget.sharedPrefsRepo.savedMinTempList;
    _savedMaxTempList = await widget.sharedPrefsRepo.savedMaxTempList;
    setState(() {
      if (_savedMinTempList != null && _savedMaxTempList != null) {
        _minTempTodayInfoText = "L: ${_savedMinTempList!.first}";
        _maxTempTodayInfoText = "H: ${_savedMaxTempList!.first}";
      }
    });
  }

  void processHighLowTempData(weatherJsonData) async {
    if (weatherJsonData == null || weatherJsonData == "") return;
    final newMinTempList = weatherJsonData["daily"]["temperature_2m_min"];
    final newMaxTempList = weatherJsonData["daily"]["temperature_2m_max"];

    _minTempTodayInfoText = "L: ${newMinTempList.first}";
    _maxTempTodayInfoText = "H: ${newMaxTempList.first}";

    await widget.sharedPrefsRepo.overrideSavedMinTempList(newMinTempList);
    await widget.sharedPrefsRepo.overrideSavedMaxTempList(newMaxTempList);
  }
}
