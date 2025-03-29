import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState(){
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try{
      String cityName = 'Chennai';
      final res = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=b0deb868d6fc4492df3298f5f84c9b6d')
      );

      final data = jsonDecode(res.body);
      if(data['cod']!='200'){
        throw 'An unexpected error occurred';
      }

      return data;


    } catch(e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          )
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {});
          }, icon: Icon(Icons.refresh))
        ],
      ),

      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          
          //Current Data
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = double.parse((currentWeatherData['main']['temp']-273).toStringAsFixed(2));
          final currentSky = currentWeatherData['weather'][0]['main'];
          final humidity = currentWeatherData['main']['humidity'];
          final windspeed = currentWeatherData['wind']['speed'];
          final pressure = currentWeatherData['main']['pressure'];

          return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp°C',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        
                            const SizedBox(height: 16,),
                        
                            Icon(
                              currentSky == 'Clouds' || currentSky == "Rain"
                              ? Icons.cloud : Icons.sunny,
                              size: 64,
                            ),
                        
                            const SizedBox(height: 16,),
                        
                            Text(
                              '$currentSky',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        
                ),
              ),
          
              const SizedBox(height: 20,),
          
              //Hourly Forecast Cards
              const Text(
                "Weather Forecast",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),       
              const SizedBox(height: 16,),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final hourlyForecast = data['list'][index+1];
                    final hourlySky = hourlyForecast['weather'][0]['main'];
                    final ftime = DateFormat.j().format(DateTime.parse(hourlyForecast['dt_txt']));
                    return HourlyForecastItem(
                      time: ftime,
                      icon: hourlySky == 'Clouds' || hourlySky == 'Rain' ? Icons.cloud : hourlySky == 'Clear' && int.parse(ftime.substring(0,2))>8 ? Icons.mode_night : Icons.sunny,
                      temp: double.parse((hourlyForecast['main']['temp']-273).toStringAsFixed(2)).toString()
                    );
                  }
                ),
              ),
        
              const SizedBox(height: 20,),
          
              //Additional Information
              const Text(
                "Additional Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),      
              const SizedBox(height: 16,),        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(
                  icon: Icons.water_drop,
                  label: "Humidity",
                  value: humidity.toString()
                  ),
                  AdditionalInfoItem(
                  icon: Icons.air,
                  label: "Wind Speed",
                  value: windspeed.toString()
                  ),
                  AdditionalInfoItem(
                  icon: Icons.beach_access,
                  label: "Pressure",
                  value: pressure.toString()
                  ),
                    ],
                  ),
                ],
              ),
          );
        },
      ),
      );
  }
}

