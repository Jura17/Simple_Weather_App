import 'package:flutter/material.dart';

class WeatherDataContainer extends StatelessWidget {
  const WeatherDataContainer(
      {super.key,
      required String tempInfoText,
      required String apparentTempInfoText,
      required String minTempTodayInfoText,
      required String maxTempTodayInfoText,
      required String humidityInfoText,
      required String rainSumInfoText,
      required Map<String, dynamic> foreCastData})
      : _tempInfoText = tempInfoText,
        _apparentTempInfoText = apparentTempInfoText,
        _minTempTodayInfoText = minTempTodayInfoText,
        _maxTempTodayInfoText = maxTempTodayInfoText,
        _humidityInfoText = humidityInfoText,
        _rainSumInfoText = rainSumInfoText,
        _foreCastData = foreCastData;

  final String _tempInfoText;
  final String _apparentTempInfoText;
  final String _minTempTodayInfoText;
  final String _maxTempTodayInfoText;
  final String _humidityInfoText;
  final String _rainSumInfoText;
  final Map<String, dynamic> _foreCastData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(_tempInfoText, style: TextStyle(fontSize: 40)),
          Text(_apparentTempInfoText, style: TextStyle(fontSize: 20)),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(_minTempTodayInfoText, style: TextStyle(fontSize: 20)),
              Text(_maxTempTodayInfoText, style: TextStyle(fontSize: 20)),
            ],
          ),
          SizedBox(height: 30),
          Text(_humidityInfoText, style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Text(_rainSumInfoText, style: TextStyle(fontSize: 20)),
          SizedBox(height: 40),
          Text("7-Tage Prognose", style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Row(
            spacing: 15,
            mainAxisSize: MainAxisSize.min,
            children: _foreCastData.keys
                .map(
                  (key) => Column(
                    children: [
                      Text(
                        "${key[0]}${key[1]}",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      Text(_foreCastData[key][1].toString(),
                          style: TextStyle(fontSize: 15)),
                      Text(_foreCastData[key][0].toString(),
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
