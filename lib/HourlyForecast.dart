import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecast({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 6,
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 35,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                temp,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
