import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import 'search_screen.dart';
import 'forecast_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WeatherProvider>().fetchWeatherByLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: _buildBackgroundGradient(
                provider.currentWeather?.mainCondition ?? '',
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => provider.refreshWeather(),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      floating: true,
                      title: Text(
                        provider.currentWeather?.cityName ?? 'Weather App',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchScreen(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.location_on, color: Colors.white),
                          onPressed: () => provider.fetchWeatherByLocation(),
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: _buildBody(provider),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(WeatherProvider provider) {
    switch (provider.state) {
      case WeatherState.initial:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Text(
              'Đang khởi động...',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        );
      case WeatherState.loading:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      case WeatherState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 60),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchWeatherByLocation(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        );
      case WeatherState.loaded:
        return Column(
          children: [
            CurrentWeatherCard(weather: provider.currentWeather!),
            const SizedBox(height: 16),
            if (provider.forecast.isNotEmpty)
              HourlyForecastList(forecasts: provider.forecast),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ForecastScreen(
                      forecasts: provider.forecast,
                    ),
                  ),
                ),
                icon: const Icon(Icons.calendar_month),
                label: const Text('Xem dự báo 5 ngày'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
    }
  }

  LinearGradient _buildBackgroundGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'clouds':
        return const LinearGradient(
          colors: [Color(0xFF546E7A), Color(0xFF90A4AE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'rain':
      case 'drizzle':
        return const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF5C6BC0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'thunderstorm':
        return const LinearGradient(
          colors: [Color(0xFF212121), Color(0xFF424242)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'snow':
        return const LinearGradient(
          colors: [Color(0xFFB0BEC5), Color(0xFFECEFF1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}