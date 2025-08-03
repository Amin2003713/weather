part of 'weather_bloc.dart';

sealed class WeatherBlocEvent extends Equatable {
  const WeatherBlocEvent();

  @override
  List<Object?> get props => [];
}

class FetchWeatherEvent extends WeatherBlocEvent {
  final LocationData data;

  const FetchWeatherEvent({required this.data});

  @override
  List<Object?> get props => [data];
}
