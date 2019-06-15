import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/blocs.dart';
import 'package:flutter_weather/pojo/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationWidget extends StatelessWidget {
  final String location;

  LocationWidget(this.location, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      location,
      style: TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}

class LastUpdate extends StatelessWidget {
  final DateTime dateTime;

  LastUpdate({Key key, this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "更新时间：${TimeOfDay.fromDateTime(dateTime).format(context)}",
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w200, color: Colors.white),
    );
  }
}

class CombinedWeatherTemperature extends StatelessWidget {
  final Weather weather;

  CombinedWeatherTemperature({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              child: WeatherConditionWidget(condition: weather.condition),
              padding: EdgeInsets.all(20),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: BlocBuilder(
                  bloc: BlocProvider.of<SettingBloc>(context),
                  builder: (context, SettingState state) {
                    return TemperatureWidget(
                        temp: weather.temp,
                        high: weather.maxTemp,
                        low: weather.minTemp,
                        unit: state.unit);
                  }),
            )
          ],
        ),
        Center(
          child: Text(
            weather.formattedCondition,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w200, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class WeatherConditionWidget extends StatelessWidget {
  final WeatherCondition condition;

  WeatherConditionWidget({Key key, this.condition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _mapConditionToImage(condition);
  }

  _mapConditionToImage(WeatherCondition _condition) {
    Image image;
    switch (_condition) {
      case WeatherCondition.clear:
      case WeatherCondition.lightCloud:
        image = Image.asset('assets/images/clear.png');
        break;
      case WeatherCondition.hail:
      case WeatherCondition.snow:
      case WeatherCondition.sleet:
        image = Image.asset('assets/images/snow.png');
        break;
      case WeatherCondition.heavyCloud:
        image = Image.asset('assets/images/cloudy.png');
        break;
      case WeatherCondition.heavyRain:
      case WeatherCondition.lightRain:
      case WeatherCondition.showers:
        image = Image.asset('assets/images/rainy.png');
        break;
      case WeatherCondition.thunderstorm:
        image = Image.asset('assets/images/thunderstorm.png');
        break;
      case WeatherCondition.unknown:
        image = Image.asset('assets/images/clear.png');
        break;
    }
    return image;
  }
}

class TemperatureWidget extends StatelessWidget {
  final double temp;
  final double high;
  final double low;
  final TemperatureUnits unit;

  TemperatureWidget({Key key, this.temp, this.high, this.low, this.unit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "${_formattedTemperature(temp)}°",
            style: TextStyle(
                fontSize: 42, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        Column(
          children: <Widget>[
            Text(
              "最高：${_formattedTemperature(high)}°",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  color: Colors.white),
            ),
            Text(
              "最高：${_formattedTemperature(low)}°",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  _formattedTemperature(double t) =>
      unit == TemperatureUnits.fahrenheit ? _toFahrenheit(t) : t.round();

  _toFahrenheit(double t) => (t * 9 / 5 + 32).round();
}

class GradientContainer extends StatelessWidget {
  final Widget child;
  final MaterialColor color;

  GradientContainer({Key key, this.child, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.6, 0.8, 1.0],
              colors: [color[700], color[500], color[300]])),
    );
  }
}
