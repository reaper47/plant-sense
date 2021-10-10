import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantsense/src/models/device_info.dart';
import 'package:plantsense/src/providers/units.dart';
import 'package:weather_icons/weather_icons.dart';

class CharacteristicTile extends ConsumerWidget {
  final Measurements measurements;

  const CharacteristicTile({Key? key, required this.measurements})
      : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isCelsius = watch(isCelsiusProvider);
    Measurement temperature =
        isCelsius ? measurements.temperatureC : measurements.temperatureF;

    return ListView(
      shrinkWrap: true,
      children: [
        buildInfoTile(measurements.temperatureIcon, temperature),
        buildInfoTile(measurements.humidityIcon, measurements.humidity),
        buildInfoTile(measurements.soilMoistureIcon, measurements.soilMoisture),
      ],
    );
  }

  Widget buildInfoTile(IconData icon, Measurement measurement) {
    Widget trailing;
    if (measurement.value == 0) {
      trailing = const SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else {
      trailing = Text(measurement.toString());
    }

    return ListTile(
      leading: BoxedIcon(icon),
      title: Text(measurement.label),
      trailing: trailing,
    );
  }
}
