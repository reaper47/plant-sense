import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:plant_sense/ui/ble_off.dart';
import 'package:plant_sense/ui/find_devices.dart';

void main() => runApp(PlantSenseApp());

class PlantSenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.greenAccent,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BleOffScreen(state: state);
          }),
    );
  }
}
