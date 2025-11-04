import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
final _controller = TextEditingController(text: 'Ho Chi Minh');


@override
void dispose() {
_controller.dispose();
super.dispose();
}


@override
Widget build(BuildContext context) {
final provider = context.watch<WeatherProvider>();


return Scaffold(
appBar: AppBar(title: const Text('Weather Now')),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
Row(
children: [
Expanded(
child: TextField(
controller: _controller,
decoration: const InputDecoration(
labelText: 'Nhập tên thành phố',
border: OutlineInputBorder(),
),
onSubmitted: (_) => _searchCity(provider),
),
),
const SizedBox(width: 8),
FilledButton(
onPressed: provider.isLoading ? null : () => _searchCity(provider),
child: const Icon(Icons.search),
),
const SizedBox(width: 8),
IconButton(
tooltip: 'Dùng vị trí của tôi',
onPressed: provider.isLoading ? null : provider.loadByCurrentLocation,
icon: const Icon(Icons.my_location),
),
],
),
const SizedBox(height: 16),
if (provider.isLoading) const LinearProgressIndicator(),
const SizedBox(height: 16),
if (provider.error != null)
Text(provider.error!, style: const TextStyle(color: Colors.red)),
if (provider.current != null) WeatherCard(data: provider.current!),
if (!provider.isLoading && provider.current == null && provider.error == null)
const Text('Hãy tìm kiếm thành phố hoặc dùng vị trí hiện tại.'),
],
),
),
);
}


void _searchCity(WeatherProvider provider) {
final q = _controller.text.trim();
if (q.isNotEmpty) {
provider.loadByCity(q);
}
}
}