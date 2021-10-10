import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:plantsense/src/consts/boxes.dart';

final isCelsiusProvider = StateNotifierProvider<IsCelciusNotifier, bool>(
    (ref) => IsCelciusNotifier());

class IsCelciusNotifier extends StateNotifier<bool> {
  final box = Hive.box<bool>(unitsBox);
  final key = 'is_celsius';

  IsCelciusNotifier() : super(true) {
    if (box.get(key) == null) {
      isCelsius = true;
    }
    state = box.get(key) ?? true;
  }

  set isCelsius(bool value) {
    box.put(key, value);
    state = value;
  }
}
