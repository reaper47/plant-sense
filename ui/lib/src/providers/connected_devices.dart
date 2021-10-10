import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device_info.dart';

final connectedDevicesProvider =
    StateNotifierProvider<ConnectedDevicesNotifier, List<DeviceInfo>>(
  (ref) => ConnectedDevicesNotifier(),
);

class ConnectedDevicesNotifier extends StateNotifier<List<DeviceInfo>> {
  ConnectedDevicesNotifier() : super([]);

  void connectDevice(BluetoothDevice device) async {
    await device.connect();

    final services = await device.discoverServices();

    for (var service in services) {
      final characteristics =
          service.characteristics.where((c) => c.properties.read);

      for (var characteristic in characteristics) {
        final values = (await characteristic.read())
            .map((e) => String.fromCharCode(e))
            .join()
            .split(',');

        if (values.length == 3) {
          final temperatureC = double.parse(values[0]);
          final humidity = double.parse(values[1]);
          final soilMoisture = double.parse(values[2]);

          final measurements = Measurements(
            temperatureC: Measurement(
              label: "Temperature",
              value: temperatureC,
              unit: "°C",
            ),
            humidity: Measurement(
              label: "Humidity",
              value: humidity,
              unit: "%",
            ),
            soilMoisture: Measurement(
              label: "Soil Moisture",
              value: soilMoisture,
              unit: "%",
            ),
          );

          state = [
            ...state,
            DeviceInfo(device: device, measurements: measurements)
          ];
          return;
        }
      }
    }

    state = [
      ...state,
      DeviceInfo(device: device, measurements: Measurements.empty()),
    ];
  }

  void disconnectDevice(BluetoothDevice device) async {
    await device.disconnect();
    state.removeWhere((d) => d.device.id.id == device.id.id);

    state = [
      for (final d in state)
        if (d.device.id.id != device.id.id) d
    ];
  }

  void disconnectDevices() async {
    for (var device in state) {
      await device.device.disconnect();
    }
  }
}
