import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService =
      WeatherService(apiKey: "a86e94221e8e2f5a9f53a3acce0ef7d4");
  Weather? _weather;
  bool _isLoading = true;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();
    // get the weather
    try {
      Weather weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      print("Failed to load weather data");
      setState(() {
        _isLoading = false;
      });
    }
  }
  //weather animations

  //init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == "Clear") {
      return 'assets/sunny2.json';
    }
    switch (mainCondition!.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return 'assets/cloud.json';
      case "rain":
      case "drizzle":
      case 'shower rain':
        return 'assets/rain.json';
      case "thunderstorm":
        return 'assets/thunder.json';
      default:
        return 'assets/sunny2.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //text name
                Text(
                  _weather?.cityName ?? "loading city name",
                  style: TextStyle(color: Colors.white),
                ),
                Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

                //temperature
                Text(
                  _weather != null
                      ? "${_weather!.temperature.round()}°C"
                      : "loading temperature",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
    );
  }
}
