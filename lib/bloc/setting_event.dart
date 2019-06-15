import 'package:equatable/equatable.dart';

abstract class SettingEvent extends Equatable {
  SettingEvent({List prop = const []}) : super(prop);
}

class TemperatureUnitsToggled extends SettingEvent {}
