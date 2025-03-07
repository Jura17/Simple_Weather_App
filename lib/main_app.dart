import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentTemperature = "Keine Wetterdaten";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("P21 Wetter-App"),
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentTemperature,
              style: TextStyle(fontSize: 30),
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: 30,
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
