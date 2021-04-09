import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:plant_sense/config.dart';
import 'package:plant_sense/ui/device.dart';
import 'package:plant_sense/ui/tiles/scan_result.dart';

const PREFIX = "Plant:";

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Plants'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                  stream: Stream.periodic(Duration(seconds: 2))
                      .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                  initialData: [],
                  builder: buildDeviceTiles),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: buildScanTiles,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) => scanButton(snapshot.data!),
      ),
    );
  }

  Widget buildDeviceTiles(
      BuildContext context, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
    return Column(
      children: snapshot.data!
          .where((d) => devices.containsKey(d.name))
          .map((d) => ListTile(
                title: Text(d.name),
                subtitle: Text(d.id.toString()),
                trailing: StreamBuilder<BluetoothDeviceState>(
                  stream: d.state,
                  initialData: BluetoothDeviceState.disconnected,
                  builder: (c, snapshot) {
                    if (snapshot.data == BluetoothDeviceState.connected) {
                      return ElevatedButton(
                        child: Text('OPEN'),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DeviceScreen(device: d),
                          ),
                        ),
                      );
                    }
                    return Text(snapshot.data.toString());
                  },
                ),
              ))
          .toList(),
    );
  }

  Widget buildScanTiles(
      BuildContext context, AsyncSnapshot<List<ScanResult>> snapshot) {
    return Column(
      children: snapshot.data!
          .where((r) => devices.containsKey(r.device.name))
          .map(
            (r) => ScanResultTile(
              result: r,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                r.device.connect();
                return DeviceScreen(device: r.device);
              })),
            ),
          )
          .toList(),
    );
  }

  Widget scanButton(bool hasData) {
    if (hasData) {
      return FloatingActionButton(
        child: Icon(Icons.stop),
        onPressed: () => FlutterBlue.instance.stopScan(),
        backgroundColor: Colors.red,
      );
    } else {
      return FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => FlutterBlue.instance.startScan(
          timeout: Duration(seconds: 4),
        ),
      );
    }
  }
}
