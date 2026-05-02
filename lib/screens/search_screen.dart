import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    context.read<WeatherProvider>().loadFavoriteCities();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', _recentSearches);
  }


  void _search(String cityName) {
    if (cityName.trim().isEmpty) return;
    if (!_recentSearches.contains(cityName)) {
      setState(() => _recentSearches.insert(0, cityName));
      _saveRecentSearches();
    }
    context.read<WeatherProvider>().fetchWeatherByCity(cityName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm thành phố'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Nhập tên thành phố...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _search(_controller.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _search,
            ),
            const SizedBox(height: 20),
            Consumer<WeatherProvider>(
              builder: (context, provider, _) {
                if (provider.favoriteCities.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thành phố yêu thích',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...provider.favoriteCities.map((city) => ListTile(
                        leading: const Icon(Icons.star, color: Colors.amber),
                        title: Text(city),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              provider.removeFavoriteCity(city),
                        ),
                        onTap: () => _search(city),
                      )),
                      const Divider(),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
            if (_recentSearches.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tìm kiếm gần đây',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ..._recentSearches.map((city) => ListTile(
                leading: const Icon(Icons.history),
                title: Text(city),
                trailing: IconButton(
                  icon: const Icon(Icons.star_border),
                  onPressed: () =>
                      context.read<WeatherProvider>().addFavoriteCity(city),
                ),
                onTap: () => _search(city),
              )),
            ],
          ],
        ),
      ),
    );
  }
}