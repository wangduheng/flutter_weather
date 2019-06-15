import 'package:bloc/bloc.dart';

import 'setting_event.dart';
import 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  @override
  SettingState get initialState => SettingState(TemperatureUnits.fahrenheit);

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is TemperatureUnitsToggled) {
      yield SettingState(
          currentState.unit == TemperatureUnits.fahrenheit ? TemperatureUnits
              .celsius : TemperatureUnits.fahrenheit);

    }
  }

}
