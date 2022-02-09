import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantsense/src/providers/units.dart';

import '../providers/connected_devices.dart';
import '../providers/scan_devices.dart';
import '../widgets/scan_result_tile.dart';

class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsyncValue = ref.watch(devicesProvider);
    final isScanningAsyncValue = ref.watch(isBluetoothScanningProvider);
    final isCelsius = ref.watch(isCelsiusProvider);

    return devicesAsyncValue.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => buildDevicesError(err),
      data: (scanResults) => buildDevicesData(
        ref, context,
        scanResults,
        isScanningAsyncValue,
        isCelsius,
      ),
    );
  }

  Widget buildDevicesError(Object err) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(err.toString()),
    );
  }

  Widget buildDevicesData(
    WidgetRef ref, BuildContext context,
    List<ScanResult> scanResults,
    AsyncValue<bool> isScanningAsyncValue,
    bool isCelsius,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plants'),
        actions: [buildTemperatureToggle(ref, context, isCelsius)],
      ),
      body: buildDevicesList(scanResults),
      floatingActionButton: FloatingActionButton(
        child: setFloatingActionButton(isScanningAsyncValue),
        onPressed: () => startScan(ref, context, isScanningAsyncValue),
        tooltip: 'Scan nearby Bluetooth devices',
      ),
    );
  }

  Widget buildTemperatureToggle(WidgetRef ref, BuildContext context, bool isCelsius) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          const Text('°F'),
          Switch(
            value: isCelsius,
            onChanged: (value) =>
                ref.read(isCelsiusProvider.notifier).isCelsius = value,
            activeTrackColor: Colors.pink,
            activeColor: Colors.white,
          ),
          const Text('°C')
        ],
      ),
    );
  }

  Widget buildDevicesList(List<ScanResult> scanResults) {
    if (scanResults.isEmpty) {
      return const Center(child: Text('No plants detected.'));
    }

    final children = scanResults
        .where((result) => result.device.name != "")
        .map((result) => ScanResultTile(result))
        .toList();

    return ListView(children: children);
  }

  Widget setFloatingActionButton(AsyncValue<bool> isScanningAsyncValue) {
    return isScanningAsyncValue.when(
      data: (isScanning) {
        if (isScanning) {
          return const CircularProgressIndicator(
            color: Colors.yellowAccent,
            strokeWidth: 2,
          );
        }
        return const Icon(Icons.search);
      },
      loading: () => const Icon(Icons.search),
      error: (err, stack) => const Icon(Icons.search),
    );
  }

  void startScan(
    WidgetRef ref, BuildContext context,
    AsyncValue<bool> isScanningAsyncValue,
  ) async {
    isScanningAsyncValue.when(
      data: (isScanning) {
        if (!isScanning) {
          ref.read(connectedDevicesProvider.notifier).disconnectDevices();
          FlutterBlue.instance.startScan(
            timeout: const Duration(seconds: 4),
          );
        }
      },
      loading: () => null,
      error: (err, stack) => null,
    );
  }
}
