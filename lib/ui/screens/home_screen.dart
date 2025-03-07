import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentTemperature = "Aktuell keine Daten vorhanden";

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    String uri =
        "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m";
    final response = await http.get(Uri.parse(uri));

    final weatherJsonData = jsonDecode(response.body);

    setState(() {
      _currentTemperature =
          "Temperatur in Berlin: ${weatherJsonData["current"]["temperature_2m"]} °C";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("P21 Wetter-App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _currentTemperature,
              style: TextStyle(fontSize: 20),
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: 40,
              ),
              onPressed: () {
                fetchWeather();
              },
            )
          ],
        ),
      ),
    );
  }
}
