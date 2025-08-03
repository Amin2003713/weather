part of 'weather_bloc.dart';

sealed class WeatherBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class WeatherInitialState extends WeatherBlocState {}

final class WeatherLoadingState extends WeatherBlocState {}

final class WeatherFailureState extends WeatherBlocState {}

final class WeatherSuccessState extends WeatherBlocState {
  final Weather weather;

  WeatherSuccessState({required this.weather});

  @override
  List<Object?> get props => [weather];
}
