import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';

class ForecastScreen extends StatelessWidget {
  final List<ForecastModel> forecasts;
  const ForecastScreen({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    final WeatherService weatherService = WeatherService();

    // Nhóm dự báo theo ngày
    final Map<String, List<ForecastModel>> groupedForecasts = {};
    for (var forecast in forecasts) {
      final day = DateFormat('yyyy-MM-dd').format(forecast.dateTime);
      groupedForecasts.putIfAbsent(day, () => []).add(forecast);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dự báo 5 ngày'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedForecasts.length,
        itemBuilder: (context, index) {
          final day = groupedForecasts.keys.elementAt(index);
          final dayForecasts = groupedForecasts[day]!;
          final date = DateTime.parse(day);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              title: Text(
                DateFormat('EEEE, dd/MM').format(date),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Min: ${dayForecasts.map((f) => f.tempMin).reduce((a, b) => a < b ? a : b).toStringAsFixed(0)}°C  '
                    'Max: ${dayForecasts.map((f) => f.tempMax).reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}°C',
              ),
              leading: Image.network(
                weatherService.getIconUrl(dayForecasts[0].icon),
                width: 50,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.cloud, size: 40),
              ),
              children: dayForecasts.map((forecast) {
                return ListTile(
                  leading: Text(
                    DateFormat('HH:mm').format(forecast.dateTime),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  title: Text(forecast.description),
                  trailing: Text(
                    '${forecast.temperature.toStringAsFixed(0)}°C',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '💧 ${forecast.humidity}%  💨 ${forecast.windSpeed.toStringAsFixed(1)} m/s',
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}