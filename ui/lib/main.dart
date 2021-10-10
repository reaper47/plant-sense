import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/app.dart';
import 'src/consts/boxes.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<bool>(unitsBox);

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
