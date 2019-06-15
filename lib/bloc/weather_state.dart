import 'package:equatable/equatable.dart';
import 'package:flutter_weather/pojo/weather.dart';

abstract class WeatherState extends Equatable {
  WeatherState({List props = const []}) : super(props);
}

class WeatherEmpty extends WeatherState {
  @override
  String toString() {
    return 'WeatherEmpty{}';
  }
}

class WeatherError extends WeatherState {
  final String error;

  WeatherError(this.error) : super(props: [error]);

  @override
  String toString() {
    return 'WeatherError{error: $error}';
  }
}

class WeatherLoading extends WeatherState {
  @override
  String toString() {
    return 'WeatherLoading{}';
  }
}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded(this.weather) : super(props: [weather]);

  @override
  String toString() {
    return 'WeatherLoaded{weather: $weather}';
  }

}
