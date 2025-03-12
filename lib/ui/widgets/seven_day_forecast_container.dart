import 'package:flutter/material.dart';
import 'package:p21_weather_app/data/repositories/shared_preferences_repository.dart';

class SevenDayForecastContainer extends StatefulWidget {
  const SevenDayForecastContainer({
    super.key,
    required this.sharedPrefsRepo,
    required this.weatherJsonData,
  });

  final SharedPreferencesRepository sharedPrefsRepo;
  final dynamic weatherJsonData;

  @override
  State<SevenDayForecastContainer> createState() =>
      _SevenDayForecastContainerState();
}

class _SevenDayForecastContainerState extends State<SevenDayForecastContainer> {
  final Map<String, dynamic> _forecastData = {};
  List<String>? _mostRecentMinTempList;
  List<String>? _mostRecentMaxTempList;
  List<String>? _mostRecentDateList;

  @override
  void initState() {
    super.initState();
    fetchRecentForecastData();
  }

  @override
  Widget build(BuildContext context) {
    processForecastData(widget.weatherJsonData);

    return Column(
      children: [
        Text("Höchst- und Tiefstwertprognose",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        SizedBox(height: 10),
        Row(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          children: _forecastData.keys
              .map(
                (key) => Column(
                  children: [
                    Text(
                      "${key[0]}${key[1]}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(_forecastData[key][1].toString(),
                        style: TextStyle(fontSize: 20)),
                    Text(_forecastData[key][0].toString(),
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              )
              .toList(),
        )
      ],
    );
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
    try {
      for (int i = 1; i < dateList.length; i++) {
        DateTime date = DateTime.parse(dateList[i]);
        String weekDay = weekDays[date.weekday - 1];
        _forecastData[weekDay] = [minTempList[i], maxTempList[i]];
      }
    } catch (e) {
      print(e);
    }
  }

  void processForecastData(weatherJsonData) async {
    if (weatherJsonData == null || weatherJsonData == "") return;
    try {
      final newMinTempList = weatherJsonData["daily"]["temperature_2m_min"];
      final newMaxTempList = weatherJsonData["daily"]["temperature_2m_max"];
      final newDateList = weatherJsonData["daily"]["time"];

      generateForecastMap(newDateList, newMinTempList, newMaxTempList);

      await widget.sharedPrefsRepo.overrideSavedDateList(newDateList);
    } catch (error) {
      // _showError = true;
      // _errorText = "Es ist ein Problem aufgetreten";
    }
  }

  void fetchRecentForecastData() async {
    _mostRecentMinTempList = await widget.sharedPrefsRepo.savedMinTempList;
    _mostRecentMaxTempList = await widget.sharedPrefsRepo.savedMaxTempList;
    _mostRecentDateList = await widget.sharedPrefsRepo.savedDateList;

    setState(() {
      if (_mostRecentMinTempList != null &&
          _mostRecentMaxTempList != null &&
          _mostRecentDateList != null) {
        generateForecastMap(_mostRecentDateList, _mostRecentMinTempList,
            _mostRecentMaxTempList);
      }
    });
  }
}
