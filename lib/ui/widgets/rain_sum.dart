import 'package:flutter/material.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';

class RainSum extends StatefulWidget {
  const RainSum({
    super.key,
    required this.sharedPrefsRepo,
    required this.weatherJsonData,
  });

  final SharedPreferencesRepository sharedPrefsRepo;
  final dynamic weatherJsonData;

  @override
  State<RainSum> createState() => _RainSumState();
}

class _RainSumState extends State<RainSum> {
  String _rainSumInfoText = "";
  double? _savedRainSum;

  @override
  void initState() {
    super.initState();
    fetchSavedRainData();
  }

  @override
  Widget build(BuildContext context) {
    processRainData(widget.weatherJsonData);
    return Text(_rainSumInfoText, style: TextStyle(fontSize: 20));
  }

  void fetchSavedRainData() async {
    _savedRainSum = await widget.sharedPrefsRepo.savedRainSum;

    setState(() {
      if (_savedRainSum != null) {
        _rainSumInfoText = "Regenmenge heute: $_savedRainSum mm";
      }
    });
  }

  void processRainData(weatherJsonData) async {
    if (weatherJsonData == null || weatherJsonData == "") return;
    final newRainSumList = weatherJsonData["daily"]["rain_sum"];
    setState(() {
      _rainSumInfoText = "Regenmenge heute: ${newRainSumList.first} mm";
    });
    await widget.sharedPrefsRepo.overrideSavedRainSum(newRainSumList.first);
  }
}
