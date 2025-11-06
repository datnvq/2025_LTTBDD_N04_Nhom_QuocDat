import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather.dart';
import '../services/weather_api.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherProvider(this._api);

  final WeatherApi _api;

  Weather? _current;
  Weather? get current => _current;

  bool _loading = false;
  bool get isLoading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> loadByCity(String city) async {
    _setLoading(true);
    try {
      _current = await _api.fetchByCity(city);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadByCurrentLocation() async {
    _setLoading(true);
    try {
      // Xin quyền và lấy vị trí
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        final req = await Geolocator.requestPermission();
        if (req == LocationPermission.denied) {
          throw Exception('Bạn đã từ chối quyền định vị.');
        }
      }
      if (await Geolocator.isLocationServiceEnabled() == false) {
        throw Exception('Hãy bật dịch vụ vị trí (GPS).');
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      _current = await _api.fetchByLocation(pos.latitude, pos.longitude);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
