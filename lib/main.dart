import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'bloc/blocs.dart';
import 'pojo/weather.dart';
import 'repositories/repositories.dart';
import 'ui/setting_page.dart';
import 'ui/widgets.dart';
void main(){
  BlocSupervisor.delegate=SimpleBlocDelegate();
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  final WeatherRepository _repository =
  WeatherRepository(WeatherApiClient(client: http.Client()));

  @override
  State<StatefulWidget> createState() {
    return WeatherAppState();
  }
}
class WeatherAppState extends State<WeatherApp> {
  ThemeBloc _themeBloc = ThemeBloc();
  SettingBloc _settingBloc = SettingBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
        blocProviders: [
          BlocProvider<ThemeBloc>(
            bloc: _themeBloc,
          ),
          BlocProvider<SettingBloc>(
            bloc: _settingBloc,
          )
        ],
        child: BlocBuilder(
            bloc: _themeBloc,
            builder: (context, ThemeState state) {
              return MaterialApp(
                theme: state.theme,
                title: "Weather App",
                home: WeatherPage(repository: widget._repository),
              );
            }));
  }

  @override
  void dispose() {
    _themeBloc.dispose();
    _settingBloc.dispose();
    super.dispose();
  }
}

class WeatherPage extends StatefulWidget {
  final WeatherRepository repository;

  WeatherPage({Key key, this.repository}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WeatherPageState();
  }
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherBloc _bloc;
  Completer<void> _refreshCompleter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final city = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CitySelectionPage()));
              if (city != null) {
                _bloc.dispatch(FetchWeather(city: city));
              }
            },
          )
        ],
      ),
      body: Center(
          child: BlocListener(
            bloc: _bloc,
            listener: (BuildContext context, WeatherState state) {
              if (state is WeatherLoaded) {
                BlocProvider.of<ThemeBloc>(context)
                    .dispatch(WeatherChanged(state.weather.condition));
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
              }
            },
            child: BlocBuilder(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is WeatherEmpty) {
                    return Center(
                      child: Text('选择一个城市'),
                    );
                  }
                  if (state is WeatherLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is WeatherError) {
                    return Center(
                      child: Text(
                        '请求错误，${state.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (state is WeatherLoaded) {
                    Weather weather = state.weather;
                    return BlocBuilder(
                        bloc: BlocProvider.of<ThemeBloc>(context),
                        builder: (_, ThemeState state) {
                          return GradientContainer(
                            color: state.color,
                            child: RefreshIndicator(
                              onRefresh: () {
                                _bloc.dispatch(RefreshWeather(weather.location));
                                return _refreshCompleter.future;
                              },
                              child: ListView(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Center(
                                      child: LocationWidget(weather.location),
                                    ),
                                  ),
                                  Center(
                                    child:
                                    LastUpdate(dateTime: weather.lastUpdated),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 50),
                                    child: Center(
                                      child: CombinedWeatherTemperature(
                                          weather: weather),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return Container();
                }),
          )),
    );
  }

  @override
  void initState() {
    _refreshCompleter = Completer();
    _bloc = WeatherBloc(widget.repository);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class CitySelectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CitySelectionPageState();
  }
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('城市选择'),
      ),
      body: Form(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: '城市', hintText: 'Chicago'),
                    ),
                  )),
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pop(context, _controller.text);
                  }),
            ],
          )),
    );
  }
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
