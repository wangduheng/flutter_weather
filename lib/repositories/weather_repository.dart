import 'package:flutter_weather/pojo/weather.dart';

import 'weather_api_client.dart';
class WeatherRepository{
  final WeatherApiClient client;

  WeatherRepository(this.client):assert(client!=null);


  Future<Weather> getWeather(String city)async{
    final int locationId=await client.getLocationId(city);
    return await client.getWeather(locationId);

  }

}