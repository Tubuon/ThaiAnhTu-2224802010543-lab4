import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final WeatherService weatherService = WeatherService();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // City & Date
          Text(
            '${weather.cityName}, ${weather.country}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, dd MMM yyyy').format(weather.dateTime),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 16),

          // Icon + Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                weatherService.getIconUrl(weather.icon),
                width: 100,
                height: 100,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.cloud, size: 80, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                '${weather.temperature.round()}°C',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),

          // Description
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cảm giác như ${weather.feelsLike.round()}°C',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 20),

          // Details row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  Icons.water_drop,
                  '${weather.humidity}%',
                  'Độ ẩm',
                ),
                _buildDivider(),
                _buildDetailItem(
                  Icons.air,
                  '${weather.windSpeed.toStringAsFixed(1)} m/s',
                  'Gió',
                ),
                _buildDivider(),
                _buildDetailItem(
                  Icons.compress,
                  '${weather.pressure} hPa',
                  'Áp suất',
                ),
                if (weather.visibility != null) ...[
                  _buildDivider(),
                  _buildDetailItem(
                    Icons.visibility,
                    '${(weather.visibility! / 1000).toStringAsFixed(1)} km',
                    'Tầm nhìn',
                  ),
                ],
              ],
            ),
          ),

          // Min / Max
          if (weather.tempMin != null && weather.tempMax != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_downward, color: Colors.lightBlueAccent, size: 16),
                Text(
                  ' ${weather.tempMin!.round()}°C',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_upward, color: Colors.orangeAccent, size: 16),
                Text(
                  ' ${weather.tempMax!.round()}°C',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white24,
    );
  }
}