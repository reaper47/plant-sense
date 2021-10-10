import 'package:flutter_blue/flutter_blue.dart';

extension AdvertisementExtensions on AdvertisementData {
  String formatServiceData() {
    final data = serviceData;
    if (data.isEmpty) {
      return 'N/A';
    }

    List<String> res = [];
    data.forEach((id, bytes) {
      final hexArray =
          '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
              .toUpperCase();

      res.add('${id.toUpperCase()}: $hexArray');
    });
    return res.join(', ');
  }
}
