import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/advertisement.dart';
import '../models/device_info.dart';
import '../providers/connected_devices.dart';
import '../widgets/advertisement_row.dart';
import 'characteristic_tile.dart';

class ScanResultTile extends ConsumerWidget {
  final ScanResult result;

  const ScanResultTile(this.result, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<DeviceInfo> deviceInfos = watch(connectedDevicesProvider);

    final deviceInfo = deviceInfos.firstWhere(
      (deviceInfo) => deviceInfo.device.id.id == result.device.id.id,
      orElse: () => DeviceInfo(
        device: result.device,
        measurements: Measurements.empty(),
      ),
    );

    final device = deviceInfo.device;
    final rssi = result.rssi;

    return ExpansionTile(
        title: Text(
          device.name.replaceFirst('Plant:', '').trim(),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          device.id.toString(),
          style: Theme.of(context).textTheme.caption,
        ),
        leading: IconButton(
          onPressed: () => showInfoDialog(context, result),
          icon: const Icon(Icons.info_outline),
        ),
        trailing: const Icon(Icons.keyboard_arrow_down),
        onExpansionChanged: (isOpen) =>
            onExpansionChanged(context, isOpen, device),
        children: [CharacteristicTile(measurements: deviceInfo.measurements)]);
  }

  void showInfoDialog(BuildContext context, ScanResult result) {
    final device = result.device;
    final deviceName = device.name.replaceFirst('Plant:', '').trim();
    final adv = result.advertisementData;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Information on $deviceName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdvertisementRow('Complete Local Name', adv.localName),
            AdvertisementRow('Tx Power Level', '${adv.txPowerLevel ?? 'N/A'}'),
            AdvertisementRow('RSSI', result.rssi.toString()),
            AdvertisementRow(
              'Service UUIDs',
              (adv.serviceUuids.isNotEmpty)
                  ? adv.serviceUuids.join(', ').toUpperCase()
                  : 'N/A',
            ),
            AdvertisementRow('Service Data', adv.formatServiceData())
          ],
        ),
      ),
    );
  }

  void onExpansionChanged(
    BuildContext context,
    bool isOpen,
    BluetoothDevice device,
  ) {
    final notifier = context.read(connectedDevicesProvider.notifier);
    if (isOpen) {
      notifier.connectDevice(device);
    } else {
      notifier.disconnectDevice(device);
    }
  }
}
