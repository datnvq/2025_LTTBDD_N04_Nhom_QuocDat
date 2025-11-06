import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherApi {
  WeatherApi({required this.apiKey});

  final String apiKey;
  static const _base = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> fetchByCity(String cityName, {String lang = 'vi'}) async {
    final uri = Uri.parse(
      '$_base/weather?q=$cityName&appid=$apiKey&lang=$lang',
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Lỗi API: ${res.statusCode} ${res.body}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return Weather.fromCurrentJson(data);
  }

  Future<Weather> fetchByLocation(
    double lat,
    double lon, {
    String lang = 'vi',
  }) async {
    final uri = Uri.parse(
      '$_base/weather?lat=$lat&lon=$lon&appid=$apiKey&lang=$lang',
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Lỗi API: ${res.statusCode} ${res.body}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return Weather.fromCurrentJson(data);
  }
}
