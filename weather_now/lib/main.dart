import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'services/weather_api.dart';
import 'screens/home_screen.dart';


void main() {
const apiKey = '029539d85ff0f0b85e875f0710f26eef';
runApp(MyApp(apiKey: apiKey));
}


class MyApp extends StatelessWidget {
const MyApp({super.key, required this.apiKey});
final String apiKey;


@override
Widget build(BuildContext context) {
return MultiProvider(
providers: [
ChangeNotifierProvider(create: (_) => WeatherProvider(WeatherApi(apiKey: apiKey))),
],
child: MaterialApp(
title: 'Weather Now',
theme: ThemeData(
useMaterial3: true,
colorSchemeSeed: const Color(0xFF4B9EFF),
brightness: Brightness.light,
),
home: const HomeScreen(),
debugShowCheckedModeBanner: false,
),
);
}
}