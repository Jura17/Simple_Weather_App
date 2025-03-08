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
  double _mostRecentTemperature = 0.0;
  TextEditingController cityController = TextEditingController();
  String _currentCity = "";

  @override
  void initState() {
    super.initState();
    fetchRecentData();
  }

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
  }

  void fetchRecentData() async {
    _currentCity = await widget.sharedPrefsRepo.recentCity;
    _mostRecentTemperature = await widget.sharedPrefsRepo.recentTemperature;

    setState(() {
      if (_currentCity.isEmpty) {
        _currentCity = "Berlin";
      }

      if (_mostRecentTemperature == 0.0) {
        _tempInfoText = "Aktuell keine Daten vorhanden";
      } else {
        _tempInfoText =
            "Temperatur in $_currentCity: $_mostRecentTemperature °C";
      }
    });
  }

  void fetchCurrentTemperature(currentCity) async {
    String? uri = apiUris[currentCity];
    if (uri == null) return;
    final response = await http.get(Uri.parse(uri));

    final weatherJsonData = jsonDecode(response.body);
    final newTemperature = weatherJsonData["current"]["temperature_2m"];

    setState(() {
      _tempInfoText = "Temperatur in $currentCity: $newTemperature °C";
    });
    await widget.sharedPrefsRepo.overrideRecentTemperature(newTemperature);
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
            Text(
              _tempInfoText,
              style: TextStyle(fontSize: 20),
            ),
            Spacer(),
            ElevatedButton.icon(
              label: Text("Aktualisieren"),
              icon: Icon(
                Icons.refresh,
                size: 40,
              ),
              onPressed: () {
                fetchCurrentTemperature(_currentCity);
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
