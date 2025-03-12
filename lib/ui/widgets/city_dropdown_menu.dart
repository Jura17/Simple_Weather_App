import 'package:flutter/material.dart';
import 'package:p21_weather_app/data/city_data.dart';

class CityDropdownMenu extends StatefulWidget {
  const CityDropdownMenu(
      {super.key,
      required this.updateCityFunc,
      required this.fetchCurrentWeatherFunc,
      required this.savedCity,
      required this.cityController});

  final Function updateCityFunc;
  final Function fetchCurrentWeatherFunc;
  final String savedCity;
  final TextEditingController cityController;

  @override
  State<CityDropdownMenu> createState() => _CityDropdownMenuState();
}

class _CityDropdownMenuState extends State<CityDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownMenu(
          initialSelection: widget.savedCity,
          controller: widget.cityController,
          onSelected: (value) {
            widget.updateCityFunc(value);
          },
          dropdownMenuEntries: cityData.keys
              .map((city) => DropdownMenuEntry(value: city, label: city))
              .toList(),
        ),
        SizedBox(height: 15),
        ElevatedButton.icon(
          label: Text("Aktualisieren"),
          icon: Icon(
            Icons.refresh,
            size: 40,
          ),
          onPressed: () {
            widget.fetchCurrentWeatherFunc(widget.savedCity);
          },
        ),
      ],
    );
  }
}
