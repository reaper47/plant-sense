import 'package:flutter_blue/flutter_blue.dart';

import 'measurement.dart';
export 'measurement.dart';

class DeviceInfo {
  final BluetoothDevice device;
  final Measurements measurements;

  DeviceInfo({required this.device, required this.measurements});
}
