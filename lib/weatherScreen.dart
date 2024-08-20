import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/HourlyForecast.dart';
import 'package:weather_app/hourlyinfo.dart';
import 'package:http/http.dart' as http;
import 'secreats.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getcurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
            'http://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openweatherAPIKey'),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }
      return data;

//
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather app',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getcurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.data != null) {}

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final CurrentWeatherTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final CurrentPressure = currentWeatherData['main']['pressure'];
          final CurrentWindspeed = currentWeatherData['wind']['speed'];
          final CurrentHumidity = currentWeatherData['main']['humidity'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$CurrentWeatherTemp K',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(currentSky)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                //  SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 39;i++)
                //         HourlyForecast(
                //           time:data['list'][i+1]['dt'].toString(),
                //           icon: data['list'][i+1]['weather'][0]['main']=='Clouds'||data['list'][i+1]['weather'][0]['main'] =='Rain' ?Icons.cloud:Icons.sunny,
                //           temp: data['list'][i+1]['weather'][0]['main'] .toString(),
                //         ),

                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlyTemp =
                          hourlyForecast['main']['temp'].toString();
                      hourlyForecast['main']['temp'].toString();
                      final HourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecast(
                        time: DateFormat.j().format(time),
                        temp: hourlyTemp,
                        icon: HourlySky == 'Clouds' || HourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    hourlyinfo(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: CurrentHumidity.toString(),
                    ),
                    hourlyinfo(
                      icon: Icons.air,
                      label: "windSpeed",
                      value: CurrentWindspeed.toString(),
                    ),
                    hourlyinfo(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: CurrentPressure.toString(),
                    ),
                  ],
                ),
                //weather forecast cards
              ],
            ),
          );
        },
      ),
    );
  }
}
