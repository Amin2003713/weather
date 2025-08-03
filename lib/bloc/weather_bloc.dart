import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';

import '../location_helper.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBloc() : super(WeatherInitialState()) {
    on<FetchWeatherEvent>((event, emit) async {
      emit(WeatherLoadingState());
      try {
        final fac = WeatherFactory(
          '4f617734a3b48f2ea2389f637116e1ba',
          language: Language.ENGLISH,
        );

        final weather = await fac.currentWeatherByLocation(
          event.data.latitude!,
          event.data.longitude!,
        );
        print(weather);
        emit(WeatherSuccessState(weather: weather));
      } catch (e) {
        emit(WeatherFailureState());
      }
    });
  }
}
