import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final devicesProvider = StreamProvider<List<ScanResult>>((ref) async* {
  FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));

  await for (final scanResult in FlutterBlue.instance.scanResults) {
    yield scanResult
        .where((result) => result.device.name.toLowerCase().startsWith("plant"))
        .toList();
  }
});

final isBluetoothScanningProvider = StreamProvider<bool>((ref) {
  return FlutterBlue.instance.isScanning;
});
