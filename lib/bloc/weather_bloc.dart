import 'package:bloc/bloc.dart';
import 'package:flutter_weather/pojo/weather.dart';
import 'package:flutter_weather/repositories/repositories.dart';

import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepository repository;

  WeatherBloc(this.repository);

  @override
  WeatherState get initialState => WeatherEmpty();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        Weather weather = await repository.getWeather(event.city);
        yield WeatherLoaded(weather);
      } catch (e) {
        yield WeatherError(e.toString());
      }
    }
    if(event is RefreshWeather){
      try {
        Weather weather = await repository.getWeather(event.city);
        yield WeatherLoaded(weather);
      } catch (e) {
        yield currentState;
      }
    }
  }
}
