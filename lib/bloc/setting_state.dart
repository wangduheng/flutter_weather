import 'package:equatable/equatable.dart';

class SettingState extends Equatable {
  TemperatureUnits unit;

  SettingState(this.unit):super([unit]);

}

enum TemperatureUnits { fahrenheit, celsius }
