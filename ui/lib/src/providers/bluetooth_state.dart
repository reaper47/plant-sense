import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluetoothStateProvider = StreamProvider.autoDispose<BluetoothState>((ref) {
  return FlutterBlue.instance.state;
});
