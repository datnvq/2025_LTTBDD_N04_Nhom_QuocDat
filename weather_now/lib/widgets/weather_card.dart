import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.data});
  final Weather data;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('HH:mm, dd/MM/yyyy');
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Location & Time
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${data.city}, ${data.country}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: theme.colorScheme.onPrimaryContainer
                                  .withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              df.format(data.time),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Weather Icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.network(
                      'https://openweathermap.org/img/wn/${data.icon}@2x.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.wb_cloudy,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Temperature & Description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Temperature
                  Text(
                    '${data.tempC.toStringAsFixed(1)}°',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                      fontSize: 72,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Description
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Celsius',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer
                                  .withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.description.toUpperCase(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Divider
              Divider(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.2),
                thickness: 1,
              ),

              const SizedBox(height: 16),

              // Weather Details Grid
              Row(
                children: [
                  // Humidity
                  Expanded(
                    child: _WeatherDetailItem(
                      icon: Icons.water_drop,
                      label: 'Độ ẩm',
                      value: '${data.humidity}%',
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  // Wind Speed
                  Expanded(
                    child: _WeatherDetailItem(
                      icon: Icons.air,
                      label: 'Gió',
                      value: '${data.windMs.toStringAsFixed(1)} m/s',
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  // Feels Like (calculated)
                  Expanded(
                    child: _WeatherDetailItem(
                      icon: Icons.thermostat,
                      label: 'Cảm giác',
                      value: '${(data.tempC - 2).toStringAsFixed(1)}°C',
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  // Weather Condition
                  Expanded(
                    child: _WeatherDetailItem(
                      icon: _getWeatherIcon(data.icon),
                      label: 'Tình trạng',
                      value: _getWeatherCondition(data.icon),
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String iconCode) {
    if (iconCode.startsWith('01')) return Icons.wb_sunny;
    if (iconCode.startsWith('02')) return Icons.wb_cloudy;
    if (iconCode.startsWith('03')) return Icons.cloud;
    if (iconCode.startsWith('04')) return Icons.cloud_queue;
    if (iconCode.startsWith('09')) return Icons.grain;
    if (iconCode.startsWith('10')) return Icons.umbrella;
    if (iconCode.startsWith('11')) return Icons.flash_on;
    if (iconCode.startsWith('13')) return Icons.ac_unit;
    if (iconCode.startsWith('50')) return Icons.blur_on;
    return Icons.wb_cloudy;
  }

  String _getWeatherCondition(String iconCode) {
    if (iconCode.startsWith('01')) return 'Quang đãng';
    if (iconCode.startsWith('02')) return 'Ít mây';
    if (iconCode.startsWith('03')) return 'Có mây';
    if (iconCode.startsWith('04')) return 'Nhiều mây';
    if (iconCode.startsWith('09')) return 'Mưa rào';
    if (iconCode.startsWith('10')) return 'Có mưa';
    if (iconCode.startsWith('11')) return 'Dông';
    if (iconCode.startsWith('13')) return 'Tuyết';
    if (iconCode.startsWith('50')) return 'Sương mù';
    return 'Không rõ';
  }
}

// Widget for weather detail item
class _WeatherDetailItem extends StatelessWidget {
  const _WeatherDetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.7)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
