import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';


class WeatherCard extends StatelessWidget {
const WeatherCard({super.key, required this.data});
final Weather data;


@override
Widget build(BuildContext context) {
final df = DateFormat('HH:mm, dd/MM');
return Card(
elevation: 4,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('${data.city}, ${data.country}', style: Theme.of(context).textTheme.titleLarge),
const SizedBox(height: 4),
Text(df.format(data.time), style: Theme.of(context).textTheme.bodySmall),
],
),
),
Image.network(
'https://openweathermap.org/img/wn/${data.icon}@2x.png',
width: 72,
height: 72,
errorBuilder: (_, __, ___) => const Icon(Icons.wb_cloudy, size: 48),
),
],
),
const SizedBox(height: 12),
Row(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Text('${data.tempC.toStringAsFixed(1)}°C', style: Theme.of(context).textTheme.displaySmall),
const SizedBox(width: 12),
Text(data.description, style: Theme.of(context).textTheme.titleMedium),
],
),
const SizedBox(height: 8),
Row(
children: [
const Icon(Icons.water_drop_outlined),
const SizedBox(width: 6),
Text('Độ ẩm: ${data.humidity}%'),
const SizedBox(width: 16),
const Icon(Icons.air),
const SizedBox(width: 6),
Text('Gió: ${data.windMs.toStringAsFixed(1)} m/s'),
],
),
],
),
),
);
}
}