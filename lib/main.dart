import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/weather_bloc.dart';
import 'package:food/pages/screans/home_screan.dart';

import 'location_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SafeArea(
        child: FutureBuilder(
          future: determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BlocProvider<WeatherBloc>(
                create: (context) =>
                    WeatherBloc()..add(FetchWeatherEvent(data: snapshot.data!)),
                child: const HomeScreen(title: 'Flutter Demo Home Page'),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: RotatingIconLoader(iconPath: 'assets/11.png'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class RotatingIconLoader extends StatelessWidget {
  final String iconPath;
  final double size;

  const RotatingIconLoader({
    super.key,
    required this.iconPath,
    this.size = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(iconPath, width: size, height: size)
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: const Duration(seconds: 2)); // چرخش بی‌پایان
  }
}
