import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    });

  @override
  Widget build(BuildContext context) {
    return Column(
                  children: [
                    Icon(icon,size: 48,),
                    SizedBox(height: 10,),
                    Text(label,style: const TextStyle(fontSize: 20,),),
                    SizedBox(height: 10,),
                    Text(value,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                  ],
                );
  }
}