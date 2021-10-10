import 'package:flutter/material.dart';

class BluetoothOffScreen extends StatelessWidget {
  final String message;

  const BluetoothOffScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildBluetoothIcon(),
            buildMessage(context),
          ],
        ),
      ),
    );
  }

  Widget buildBluetoothIcon() {
    return const Icon(
      Icons.bluetooth_disabled,
      size: 200,
      color: Colors.white54,
    );
  }

  Widget buildMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Bluetooth Adapter is unavailable because $message.',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .primaryTextTheme
            .subtitle1
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
