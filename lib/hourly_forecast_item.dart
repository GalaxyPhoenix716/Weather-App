import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
    });

  @override
  Widget build(BuildContext context) {
    return Card(
                child: Container(
                  width: 118,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    children: [
                      Text(time,style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              
                      SizedBox(height: 8),
                  
                      Icon(icon, size: 38),
                              
                      SizedBox(height: 20,),
                  
                      Text(temp),
                    ],
                  ),
                ),
              );
  }
}