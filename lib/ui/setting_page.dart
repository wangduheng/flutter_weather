import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/blocs.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingBloc settingBloc = BlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: ListView(
        children: <Widget>[
          BlocBuilder(
              bloc: settingBloc,
              builder: (context, SettingState state) {
                return ListTile(
                  title: Text("Temperature Units"),
                  isThreeLine: true,
                  subtitle:
                  Text('Use metric measurements for temperature units.'),
                  trailing: Switch(
                      value: state.unit == TemperatureUnits.celsius,
                      onChanged: (value) =>
                          settingBloc.dispatch(TemperatureUnitsToggled())),
                );
              })
        ],
      ),
    );
  }
}
