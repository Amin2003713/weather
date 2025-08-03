import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/weather_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'dart:ui'
    show Image, ImageFilter, SemanticsInputType, TextHeightBehavior;

import 'package:weather_icons/weather_icons.dart';

import '../../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  String _formattedDate() {
    final now = DateTime.now();

    // List of weekdays starting from Monday (1) to Sunday (7)
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    // DateTime.weekday returns 1 for Monday ... 7 for Sunday
    final weekday = weekdays[now.weekday - 1];

    // Format hour in 12-hour format
    final hour12 = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final ampm = now.hour >= 12 ? 'PM' : 'AM';

    // Format minutes with leading zero
    final minute = now.minute.toString().padLeft(2, '0');

    return '$weekday ${now.day} - $hour12:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0.6 * kToolbarHeight, 20, 10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BlocBuilder<WeatherBloc, WeatherBlocState>(
            builder: (context, snap) {
              if (snap is WeatherLoadingState || snap is WeatherInitialState) {
                return Center(
                  child: RotatingIconLoader(iconPath: 'assets/11.png'),
                );
              } else {
                var weather = (snap as WeatherSuccessState).weather;
                return Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(3, 0.2),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 147, 55, 175),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-3, 0.3),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 146, 55, 174),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(228, 54, 51, 51),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, -0.7),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color.fromARGB(255, 234, 218, 101),
                        ),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.transparent),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            style: ListTileStyle.drawer,
                            title: Text(
                              'Good morning',
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.pin_drop,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  weather.areaName!,
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                _getPath(weather.weatherMain ?? 'Clear'),
                              ),
                              Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      weather.temperature!.celsius!
                                          .toStringAsFixed(2),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Colors.white,
                                            fontSize: 55,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Icon(
                                      WeatherIcons.celsius,
                                      size: 78,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Text(
                                  weather.weatherMain ?? 'Clear',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: Colors.white38),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formattedDate(), // Custom method
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white70,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //sunrise
                                  _buildInfos(
                                    context,
                                    'sunrise',
                                    DateFormat().add_jmv().format(
                                      weather.sunrise!,
                                    ),
                                    'assets/11.png',
                                  ),
                                  // sunset
                                  _buildInfos(
                                    context,
                                    'sunset',
                                    DateFormat().add_jmv().format(
                                      weather.sunset!,
                                    ),
                                    'assets/12.png',
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color: Colors.grey.withAlpha(100),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildInfos(
                                    context,
                                    'Max Temp',
                                    weather.tempMax!.celsius!.toStringAsFixed(
                                      2,
                                    ),
                                    'assets/13.png',
                                  ),
                                  _buildInfos(
                                    context,
                                    'Min Temp',
                                    weather.tempMin!.celsius!.toStringAsFixed(
                                      2,
                                    ),
                                    'assets/14.png',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfos(
    BuildContext context,
    String text,
    String time,
    String iconPath,
  ) => Row(
    children: [
      Image.asset(iconPath, scale: 8, fit: BoxFit.cover),
      SizedBox(width: 5),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(color: Colors.white54),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ],
  );

  String _getPath(String s) => switch (s.toLowerCase()) {
    'clear' => 'assets/6.png',
    'clouds' => 'assets/8.png',
    'rain' => 'assets/3.png',
    'snow' => 'assets/4.png',
    'thunderstorm' => 'assets/1.png',
    'drizzle' => 'assets/9.png',
    'mist' || 'fog' => 'assets/5.png',
    _ => 'assets/icons/11.png',
  };
}
