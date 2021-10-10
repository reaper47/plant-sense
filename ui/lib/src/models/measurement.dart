import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class Measurements {
  final Measurement temperatureC;
  late final Measurement temperatureF;
  final Measurement humidity;
  final Measurement soilMoisture;

  Measurements({
    required this.temperatureC,
    required this.humidity,
    required this.soilMoisture,
  }) : temperatureF = Measurement(
          label: "Temperature",
          value: (temperatureC.value * 9 / 5) + 32,
          unit: "°F",
        );

  Measurements.empty()
      : temperatureC = const Measurement(
          label: "Temperature",
          value: 0,
          unit: "°C",
        ),
        temperatureF = const Measurement(
          label: "Temperature",
          value: 0,
          unit: "°F",
        ),
        humidity = const Measurement(
          label: "Humidity",
          value: 0,
          unit: "%",
        ),
        soilMoisture = const Measurement(
          label: "Soil Moisture",
          value: 0,
          unit: "°F",
        );

  IconData get temperatureIcon => WeatherIcons.thermometer;
  IconData get humidityIcon => WeatherIcons.humidity;
  IconData get soilMoistureIcon => WeatherIcons.raindrop;
}

class Measurement {
  final String label;
  final double value;
  final String unit;

  const Measurement({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  String toString() => '${value.toStringAsFixed(2)}$unit';
}
