import 'package:flutter_weather/pojo/weather.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';

class WeatherApiClient {
  static const baseUrl = 'https://www.metaweather.com';
  final http.Client client;

  WeatherApiClient({@required this.client}) : assert(client != null);

  Future<int> getLocationId(String city) async {
    final locationUrl = "$baseUrl/api/location/search/?query=$city";
    final locationResponse = await this.client.get(locationUrl);
    if (locationResponse.statusCode != 200) {
      throw Exception("error getting locationId for city");
    }
    final locationJson = jsonDecode(locationResponse.body) as List;
    return (locationJson.first)['woeid'];
  }

  Future<Weather> getWeather(int locationId) async {
    final weatherUrl = "$baseUrl/api/location/$locationId";
    final weatherResponse = await this.client.get(weatherUrl);
    if (weatherResponse.statusCode != 200) {
      throw Exception('error getting weather for location');
    }
    final weatherJson = jsonDecode(weatherResponse.body);
    return Weather.fromJson(weatherJson);
  }
}
