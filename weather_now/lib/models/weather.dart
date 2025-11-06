class Weather {
  final String city;
  final String country;
  final double tempC;
  final String description;
  final String icon; // mã icon từ OpenWeatherMap
  final int humidity;
  final double windMs;
  final DateTime time;

  Weather({
    required this.city,
    required this.country,
    required this.tempC,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windMs,
    required this.time,
  });

  factory Weather.fromCurrentJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? '') as String;
    final sys = (json['sys'] ?? {}) as Map<String, dynamic>;
    final main = (json['main'] ?? {}) as Map<String, dynamic>;
    final weatherArr = (json['weather'] ?? []) as List;
    final wind = (json['wind'] ?? {}) as Map<String, dynamic>;
    final dt =
        json['dt'] as int? ?? (DateTime.now().millisecondsSinceEpoch ~/ 1000);

    final w0 = weatherArr.isNotEmpty
        ? weatherArr.first as Map<String, dynamic>
        : {};

    return Weather(
      city: name,
      country: (sys['country'] ?? '') as String,
      tempC:
          ((main['temp'] as num?)?.toDouble() ?? 0.0) - 273.15, // Kelvin -> C
      description: (w0['description'] ?? '') as String,
      icon: (w0['icon'] ?? '01d') as String,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windMs: ((wind['speed'] as num?)?.toDouble() ?? 0.0),
      time: DateTime.fromMillisecondsSinceEpoch(
        dt * 1000,
        isUtc: true,
      ).toLocal(),
    );
  }
}
