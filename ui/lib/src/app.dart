import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantsense/src/providers/bluetooth_state.dart';
import 'package:plantsense/src/screens/bluetooth_off.dart';

import 'screens/devices.dart';

class App extends ConsumerWidget {
  final title = 'Plant Sense';

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsyncValue = ref.watch(bluetoothStateProvider);

    return stateAsyncValue.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => buildBluetoothOffScreen(context, err),
      data: (state) => buildMaterialApp(context, state),
    );
  }

  Widget buildMaterialApp(BuildContext context, BluetoothState state) {
    if (state == BluetoothState.off) {
      return buildBluetoothOffScreen(context, 'Bluetooth is turned off');
    }

    return MaterialApp(
      title: title,
      home: const DevicesScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(color: Colors.green[700]),
        primaryColor: Colors.green[700],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }

  Widget buildBluetoothOffScreen(BuildContext context, Object? err) {
    late String message;
    switch (err.runtimeType) {
      case PlatformException:
        message = (err as PlatformException).message!;
        break;
      default:
        message = err.toString();
    }

    return MaterialApp(
      title: title,
      color: Colors.lightBlue,
      home: BluetoothOffScreen(message: message),
    );
  }
}
