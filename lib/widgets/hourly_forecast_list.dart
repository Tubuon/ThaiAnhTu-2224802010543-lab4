import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const HourlyForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    final WeatherService weatherService = WeatherService();

    // Lấy tối đa 8 mốc giờ tiếp theo (8 x 3h = 24 giờ)
    final hourlyList = forecasts.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Dự báo 24 giờ tới',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: hourlyList.length,
            itemBuilder: (context, index) {
              final forecast = hourlyList[index];
              final isNow = index == 0;

              return Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                decoration: BoxDecoration(
                  color: isNow ? Colors.white24 : Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                  border: isNow
                      ? Border.all(color: Colors.white38, width: 1)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Giờ
                    Text(
                      isNow
                          ? 'Hiện tại'
                          : DateFormat('HH:mm').format(forecast.dateTime),
                      style: TextStyle(
                        color: isNow ? Colors.white : Colors.white70,
                        fontSize: 11,
                        fontWeight: isNow
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Icon thời tiết
                    Image.network(
                      weatherService.getIconUrl(forecast.icon),
                      width: 36,
                      height: 36,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.cloud, color: Colors.white70, size: 30),
                    ),

                    // Nhiệt độ
                    Text(
                      '${forecast.temperature.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Độ ẩm
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: Colors.lightBlueAccent,
                          size: 10,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${forecast.humidity}%',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}