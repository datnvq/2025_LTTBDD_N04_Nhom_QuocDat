import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_skeleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController(text: 'Ho Chi Minh');
  String _selectedCountry = 'VN';

  // Danh sách quốc gia/khu vực phổ biến
  final Map<String, String> _countries = {
    'VN': '🇻🇳 Việt Nam',
    'US': '🇺🇸 Hoa Kỳ',
    'GB': '🇬🇧 Anh',
    'JP': '🇯🇵 Nhật Bản',
    'KR': '🇰🇷 Hàn Quốc',
    'CN': '🇨🇳 Trung Quốc',
    'TH': '🇹🇭 Thái Lan',
    'SG': '🇸🇬 Singapore',
    'FR': '🇫🇷 Pháp',
    'DE': '🇩🇪 Đức',
  };

  // Thành phố phổ biến theo quốc gia
  final Map<String, List<String>> _popularCities = {
    'VN': ['Hà Nội', 'Hồ Chí Minh', 'Đà Nẵng', 'Hải Phòng', 'Nha Trang'],
    'US': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Miami'],
    'GB': ['London', 'Manchester', 'Birmingham', 'Liverpool', 'Edinburgh'],
    'JP': ['Tokyo', 'Osaka', 'Kyoto', 'Yokohama', 'Nagoya'],
    'KR': ['Seoul', 'Busan', 'Incheon', 'Daegu', 'Gwangju'],
    'CN': ['Beijing', 'Shanghai', 'Guangzhou', 'Shenzhen', 'Chengdu'],
    'TH': ['Bangkok', 'Chiang Mai', 'Phuket', 'Pattaya', 'Krabi'],
    'SG': ['Singapore'],
    'FR': ['Paris', 'Marseille', 'Lyon', 'Toulouse', 'Nice'],
    'DE': ['Berlin', 'Munich', 'Hamburg', 'Frankfurt', 'Cologne'],
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primaryContainer.withOpacity(0.3),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Row(
                  children: [
                    Icon(Icons.wb_sunny, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Weather Now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Search Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tìm kiếm thời tiết',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Country Selector
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.outline.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCountry,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: _countries.entries.map((entry) {
                                    return DropdownMenuItem(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCountry = value!;
                                      // Set thành phố đầu tiên của quốc gia được chọn
                                      final cities = _popularCities[_selectedCountry];
                                      if (cities != null && cities.isNotEmpty) {
                                        _controller.text = cities.first;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // City Input
                            TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                labelText: 'Tên thành phố',
                                hintText: 'Nhập tên thành phố...',
                                prefixIcon: const Icon(Icons.location_city),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                              ),
                              onSubmitted: (_) => _searchCity(provider),
                            ),
                            const SizedBox(height: 12),

                            // Popular Cities Chips
                            if (_popularCities[_selectedCountry] != null)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _popularCities[_selectedCountry]!
                                    .map((city) => ActionChip(
                                          label: Text(city),
                                          avatar: const Icon(Icons.location_on, size: 16),
                                          onPressed: () {
                                            setState(() {
                                              _controller.text = city;
                                            });
                                            _searchCity(provider);
                                          },
                                        ))
                                    .toList(),
                              ),
                            const SizedBox(height: 16),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: provider.isLoading
                                        ? null
                                        : () => _searchCity(provider),
                                    icon: const Icon(Icons.search),
                                    label: const Text('Tìm kiếm'),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                FilledButton.tonalIcon(
                                  onPressed: provider.isLoading
                                      ? null
                                      : provider.loadByCurrentLocation,
                                  icon: const Icon(Icons.my_location),
                                  label: const Text('Vị trí'),
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Loading Indicator with Skeleton
                    if (provider.isLoading)
                      const WeatherSkeleton(),

                    // Error Message
                    if (provider.error != null)
                      Card(
                        color: theme.colorScheme.errorContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  provider.error!,
                                  style: TextStyle(
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Weather Card
                    if (provider.current != null)
                      WeatherCard(data: provider.current!),

                    // Empty State
                    if (!provider.isLoading &&
                        provider.current == null &&
                        provider.error == null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.cloud_outlined,
                                size: 64,
                                color: theme.colorScheme.primary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Chào mừng đến Weather Now!',
                                style: theme.textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tìm kiếm thành phố hoặc sử dụng\nvị trí hiện tại để xem thời tiết',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _searchCity(WeatherProvider provider) {
    final q = _controller.text.trim();
    if (q.isNotEmpty) {
      // Thêm mã quốc gia vào query để tìm chính xác hơn
      final query = '$q,${_selectedCountry.toLowerCase()}';
      provider.loadByCity(query);
    }
  }
}