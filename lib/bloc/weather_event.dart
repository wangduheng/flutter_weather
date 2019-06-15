import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  WeatherEvent({List prop = const []}) : super(prop);
}

class FetchWeather extends WeatherEvent {
  final String city;

  FetchWeather({this.city}) : super(prop: [city]);

  @override
  String toString() {
    return 'FetchWeather{city: $city}';
  }
}

class RefreshWeather extends WeatherEvent {
  final String city;

  RefreshWeather(this.city);

  @override
  String toString() {
    return 'RefreshWeather{city: $city}';
  }
}
