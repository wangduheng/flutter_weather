import 'package:equatable/equatable.dart';
import 'package:flutter_weather/pojo/weather.dart';

abstract class ThemeEvent extends Equatable {
  ThemeEvent([List prop = const []]) : super(prop);
}

class WeatherChanged extends ThemeEvent {
  final WeatherCondition condition;

  WeatherChanged(this.condition) : super([condition]);
}