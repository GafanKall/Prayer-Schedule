import 'dart:convert';
import 'package:flutter_application_1/jadwal_sholat.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<PrayerTimes> getPrayerTimes(String city, String country) async {
    final url = Uri.parse('https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final timings = json['data']['timings'];
      return PrayerTimes.fromJson(timings);
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
