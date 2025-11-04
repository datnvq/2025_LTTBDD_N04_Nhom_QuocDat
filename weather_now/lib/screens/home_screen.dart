import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/weather_provider.dart';
import '../providers/locale_provider.dart';
import '../models/weather.dart';
import '../services/weather_api.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_skeleton.dart';
import '../utils/localization_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController(text: 'Ho Chi Minh');
  String _selectedCountry = 'VN';
  String? _selectedCity;
  final List<String> _favoriteCities = ['Hồ Chí Minh', 'Hà Nội', 'Đà Nẵng']; // Danh sách yêu thích
  List<String> _searchHistory = []; // Lịch sử tìm kiếm
  List<String> _compareList = []; // Danh sách thành phố để so sánh (max 2)
  Map<String, Weather?> _compareWeatherData = {}; // Dữ liệu thời tiết cho so sánh
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

  // Danh sách đầy đủ các tỉnh/thành phố theo quốc gia
  final Map<String, List<String>> _allCities = {
    'VN': [
      'Hà Nội',
      'Hồ Chí Minh',
      'Đà Nẵng',
      'Hải Phòng',
      'Cần Thơ',
      'Nha Trang',
      'Huế',
      'Vinh',
      'Buôn Ma Thuột',
      'Quy Nhơn',
      'Vũng Tàu',
      'Phan Thiết',
      'Đà Lạt',
      'Pleiku',
      'Biên Hòa',
      'Thủ Dầu Một',
      'Long Xuyên',
      'Mỹ Tho',
      'Rạch Giá',
      'Cà Mau',
      'Bến Tre',
      'Vĩnh Long',
      'Trà Vinh',
      'Sóc Trăng',
      'Bạc Liêu',
      'Châu Đốc',
      'Tây Ninh',
      'Phan Rang',
      'Cam Ranh',
      'Kon Tum',
      'Gia Lai',
      'Đắk Lắk',
      'Lâm Đồng',
      'Ninh Thuận',
      'Bình Thuận',
      'Đồng Nai',
      'Bà Rịa',
      'Bình Dương',
      'Bình Phước',
      'Long An',
      'Tiền Giang',
      'Bến Tre',
      'Đồng Tháp',
      'An Giang',
      'Kiên Giang',
      'Hậu Giang',
      'Sóc Trăng',
      'Nam Định',
      'Thái Bình',
      'Hưng Yên',
      'Hà Nam',
      'Ninh Bình',
      'Thanh Hóa',
      'Nghệ An',
      'Hà Tĩnh',
      'Quảng Bình',
      'Quảng Trị',
      'Thừa Thiên Huế',
      'Quảng Nam',
      'Quảng Ngãi',
      'Bình Định',
      'Phú Yên',
      'Khánh Hòa',
    ],
    'US': [
      'New York',
      'Los Angeles',
      'Chicago',
      'Houston',
      'Phoenix',
      'Philadelphia',
      'San Antonio',
      'San Diego',
      'Dallas',
      'San Jose',
      'Austin',
      'Jacksonville',
      'Fort Worth',
      'Columbus',
      'San Francisco',
      'Charlotte',
      'Indianapolis',
      'Seattle',
      'Denver',
      'Washington DC',
      'Boston',
      'El Paso',
      'Nashville',
      'Detroit',
      'Oklahoma City',
      'Portland',
      'Las Vegas',
      'Memphis',
      'Louisville',
      'Baltimore',
      'Milwaukee',
      'Albuquerque',
      'Tucson',
      'Fresno',
      'Sacramento',
      'Kansas City',
      'Mesa',
      'Atlanta',
      'Omaha',
      'Colorado Springs',
      'Raleigh',
      'Miami',
      'Virginia Beach',
      'Oakland',
      'Minneapolis',
      'Tulsa',
      'Arlington',
      'Tampa',
      'New Orleans',
    ],
    'GB': [
      'London',
      'Birmingham',
      'Manchester',
      'Glasgow',
      'Liverpool',
      'Newcastle',
      'Sheffield',
      'Bristol',
      'Belfast',
      'Leicester',
      'Edinburgh',
      'Leeds',
      'Cardiff',
      'Coventry',
      'Bradford',
      'Nottingham',
      'Kingston upon Hull',
      'Plymouth',
      'Stoke-on-Trent',
      'Wolverhampton',
      'Derby',
      'Southampton',
      'Portsmouth',
      'Brighton',
      'Reading',
      'Oxford',
      'Cambridge',
      'York',
      'Norwich',
      'Swansea',
    ],
    'JP': [
      'Tokyo',
      'Yokohama',
      'Osaka',
      'Nagoya',
      'Sapporo',
      'Fukuoka',
      'Kobe',
      'Kyoto',
      'Kawasaki',
      'Saitama',
      'Hiroshima',
      'Sendai',
      'Chiba',
      'Kitakyushu',
      'Sakai',
      'Niigata',
      'Hamamatsu',
      'Kumamoto',
      'Sagamihara',
      'Shizuoka',
      'Okayama',
      'Kagoshima',
      'Hachioji',
      'Funabashi',
      'Kawaguchi',
      'Himeji',
      'Suita',
      'Utsunomiya',
      'Matsuyama',
      'Nara',
      'Toyama',
      'Nagasaki',
      'Kanazawa',
      'Oita',
      'Kochi',
      'Naha',
    ],
    'KR': [
      'Seoul',
      'Busan',
      'Incheon',
      'Daegu',
      'Daejeon',
      'Gwangju',
      'Suwon',
      'Ulsan',
      'Changwon',
      'Seongnam',
      'Goyang',
      'Yongin',
      'Bucheon',
      'Cheongju',
      'Ansan',
      'Jeonju',
      'Cheonan',
      'Namyangju',
      'Hwaseong',
      'Pohang',
      'Jeju',
      'Gimhae',
      'Pyeongtaek',
      'Siheung',
      'Uijeongbu',
      'Paju',
      'Gimpo',
      'Jinju',
      'Iksan',
      'Gwangmyeong',
    ],
    'CN': [
      'Beijing',
      'Shanghai',
      'Guangzhou',
      'Shenzhen',
      'Chengdu',
      'Chongqing',
      'Tianjin',
      'Wuhan',
      'Dongguan',
      'Hangzhou',
      'Foshan',
      'Nanjing',
      'Shenyang',
      'Harbin',
      "Xi'an",
      'Suzhou',
      'Qingdao',
      'Zhengzhou',
      'Changsha',
      'Dalian',
      'Jinan',
      'Shantou',
      'Kunming',
      'Changchun',
      'Shijiazhuang',
      'Taiyuan',
      'Nanning',
      'Guiyang',
      'Ningbo',
      'Wenzhou',
      'Xiamen',
      'Fuzhou',
      'Nanchang',
      'Hefei',
      'Urumqi',
      'Lanzhou',
      'Hohhot',
      'Yinchuan',
      'Xining',
      'Lhasa',
      'Hong Kong',
      'Macau',
    ],
    'TH': [
      'Bangkok',
      'Chiang Mai',
      'Phuket',
      'Pattaya',
      'Krabi',
      'Hua Hin',
      'Chiang Rai',
      'Koh Samui',
      'Ayutthaya',
      'Sukhothai',
      'Udon Thani',
      'Khon Kaen',
      'Nakhon Ratchasima',
      'Hat Yai',
      'Surat Thani',
      'Nakhon Si Thammarat',
      'Phitsanulok',
      'Ubon Ratchathani',
      'Lampang',
      'Kanchanaburi',
      'Songkhla',
      'Rayong',
      'Nonthaburi',
      'Pak Kret',
      'Samut Prakan',
    ],
    'SG': [
      'Singapore',
      'Jurong',
      'Woodlands',
      'Tampines',
      'Bedok',
      'Hougang',
      'Yishun',
      'Sengkang',
      'Punggol',
      'Bukit Batok',
      'Bukit Panjang',
      'Pasir Ris',
      'Ang Mo Kio',
      'Toa Payoh',
      'Clementi',
      'Serangoon',
      'Geylang',
      'Marine Parade',
      'Orchard',
      'Changi',
    ],
    'FR': [
      'Paris',
      'Marseille',
      'Lyon',
      'Toulouse',
      'Nice',
      'Nantes',
      'Strasbourg',
      'Montpellier',
      'Bordeaux',
      'Lille',
      'Rennes',
      'Reims',
      'Le Havre',
      'Saint-Étienne',
      'Toulon',
      'Grenoble',
      'Dijon',
      'Angers',
      'Nîmes',
      'Villeurbanne',
      'Saint-Denis',
      'Le Mans',
      'Aix-en-Provence',
      'Clermont-Ferrand',
      'Brest',
      'Tours',
      'Amiens',
      'Limoges',
      'Annecy',
      'Perpignan',
      'Boulogne-Billancourt',
      'Metz',
      'Besançon',
      'Orléans',
      'Rouen',
      'Cannes',
      'Monaco',
    ],
    'DE': [
      'Berlin',
      'Hamburg',
      'Munich',
      'Cologne',
      'Frankfurt',
      'Stuttgart',
      'Düsseldorf',
      'Dortmund',
      'Essen',
      'Leipzig',
      'Bremen',
      'Dresden',
      'Hanover',
      'Nuremberg',
      'Duisburg',
      'Bochum',
      'Wuppertal',
      'Bielefeld',
      'Bonn',
      'Münster',
      'Karlsruhe',
      'Mannheim',
      'Augsburg',
      'Wiesbaden',
      'Gelsenkirchen',
      'Mönchengladbach',
      'Braunschweig',
      'Chemnitz',
      'Kiel',
      'Aachen',
      'Halle',
      'Magdeburg',
      'Freiburg',
      'Krefeld',
      'Lübeck',
      'Oberhausen',
      'Erfurt',
      'Mainz',
      'Rostock',
      'Kassel',
      'Hagen',
      'Potsdam',
      'Heidelberg',
    ],
  };

  // Danh sách thành phố phổ biến (top 5) để hiển thị chips
  Map<String, List<String>> get _popularCities => {
    'VN': _allCities['VN']!.take(5).toList(),
    'US': _allCities['US']!.take(5).toList(),
    'GB': _allCities['GB']!.take(5).toList(),
    'JP': _allCities['JP']!.take(5).toList(),
    'KR': _allCities['KR']!.take(5).toList(),
    'CN': _allCities['CN']!.take(5).toList(),
    'TH': _allCities['TH']!.take(5).toList(),
    'SG': _allCities['SG']!.take(5).toList(),
    'FR': _allCities['FR']!.take(5).toList(),
    'DE': _allCities['DE']!.take(5).toList(),
  };

  @override
  void initState() {
    super.initState();
    // Set giá trị ban đầu cho city dropdown
    _selectedCity = _allCities[_selectedCountry]?.first;
    // Load search history
    _loadSearchHistory();
    // Animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final theme = Theme.of(context);
    final strings = S.of(context);

    return Scaffold(
      drawer: _buildDrawer(context),
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
                expandedHeight: 120,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.1),
                        theme.colorScheme.secondary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                leading: Builder(
                  builder: (context) => Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      tooltip: 'Menu',
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      strings.appTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        letterSpacing: 0.5,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: provider.isLoading ? null : () {
                        if (_controller.text.isNotEmpty) {
                          _searchCity(provider);
                        }
                      },
                      tooltip: 'Refresh',
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Search Card
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primaryContainer.withOpacity(0.3),
                            theme.colorScheme.secondaryContainer.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.primary,
                                          theme.colorScheme.secondary,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary.withOpacity(0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.travel_explore_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          strings.searchWeather,
                                          style: theme.textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: theme.colorScheme.onSurface,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        Text(
                                          'Khám phá thời tiết toàn cầu',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Country Selector
                              Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCountry,
                                  isExpanded: true,
                                  icon: Icon(Icons.expand_more_rounded, color: theme.colorScheme.onSurfaceVariant),
                                  hint: Text(strings.selectCountry),
                                  borderRadius: BorderRadius.circular(16),
                                  items: _countries.entries.map((entry) {
                                    return DropdownMenuItem(
                                      value: entry.key,
                                      child: Row(
                                        children: [
                                          Text(entry.value, style: const TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCountry = value!;
                                      // Reset city selection khi đổi quốc gia
                                      _selectedCity = null;
                                      // Set thành phố đầu tiên của quốc gia được chọn
                                      final cities = _allCities[_selectedCountry];
                                      if (cities != null && cities.isNotEmpty) {
                                        _selectedCity = cities.first;
                                        _controller.text = cities.first;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                              // City Dropdown Selector
                              Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCity,
                                  isExpanded: true,
                                  icon: Icon(Icons.expand_more_rounded, color: theme.colorScheme.onSurfaceVariant),
                                  hint: Text(strings.selectCity),
                                  borderRadius: BorderRadius.circular(16),
                                  items: _allCities[_selectedCountry]?.map((city) {
                                    return DropdownMenuItem(
                                      value: city,
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_city, size: 18, color: theme.colorScheme.primary),
                                          const SizedBox(width: 8),
                                          Text(city, style: const TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCity = value;
                                      if (value != null) {
                                        _controller.text = value;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                              // City Input (có thể nhập tay)
                              TextField(
                              controller: _controller,
                              style: const TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                labelText: strings.orEnterCity,
                                hintText: strings.enterCityName,
                                prefixIcon: Icon(Icons.edit_location_alt_rounded, color: theme.colorScheme.primary),
                                suffixIcon: _controller.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear_rounded),
                                        onPressed: () {
                                          setState(() {
                                            _controller.clear();
                                            _selectedCity = null;
                                          });
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceContainerHigh,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              onSubmitted: (_) => _searchCity(provider),
                              onChanged: (value) {
                                // Sync với dropdown nếu trùng
                                setState(() {
                                  if (_allCities[_selectedCountry]?.contains(value) ?? false) {
                                    _selectedCity = value;
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 20),

                              // Popular Cities Chips (Thành phố nổi bật)
                              if (_popularCities[_selectedCountry] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    strings.popularCities,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: _popularCities[_selectedCountry]!
                                        .map((city) => FilterChip(
                                              label: Text(city, style: const TextStyle(fontSize: 13)),
                                              avatar: Icon(Icons.location_on_rounded, size: 18, 
                                                color: _selectedCity == city 
                                                  ? theme.colorScheme.onPrimary 
                                                  : theme.colorScheme.primary),
                                              selected: _selectedCity == city,
                                              selectedColor: theme.colorScheme.primaryContainer,
                                              backgroundColor: theme.colorScheme.surfaceContainerHigh,
                                              onSelected: (selected) {
                                                setState(() {
                                                  _selectedCity = city;
                                                  _controller.text = city;
                                                });
                                                _searchCity(provider);
                                                _saveSearchHistory(city);
                                              },
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 24),

                              // Action Buttons
                              Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.primary,
                                          theme.colorScheme.secondary,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary.withOpacity(0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: provider.isLoading
                                          ? null
                                          : () => _searchCity(provider),
                                      icon: const Icon(Icons.search_rounded, size: 24, color: Colors.white),
                                      label: Text(
                                        strings.search,
                                        style: const TextStyle(
                                          fontSize: 17, 
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.tertiary,
                                          theme.colorScheme.tertiaryContainer,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.tertiary.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: provider.isLoading
                                          ? null
                                          : provider.loadByCurrentLocation,
                                      icon: const Icon(Icons.my_location_rounded, size: 22, color: Colors.white),
                                      label: Text(
                                        strings.location,
                                        style: const TextStyle(
                                          fontSize: 15, 
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Favorites Cities Section
                    if (!provider.isLoading && provider.current == null && provider.error == null)
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.tertiaryContainer.withOpacity(0.3),
                                theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: theme.colorScheme.tertiary.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.tertiary,
                                          theme.colorScheme.tertiaryContainer,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.tertiary.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    strings.favoriteCities,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _favoriteCities.map((city) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _controller.text = city;
                                        _selectedCity = city;
                                      });
                                      _searchCity(provider);
                                      _saveSearchHistory(city);
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.colorScheme.primaryContainer,
                                            theme.colorScheme.secondaryContainer,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.colorScheme.primary.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.location_city_rounded,
                                            size: 18,
                                            color: theme.colorScheme.primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            city,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.onPrimaryContainer,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Loading Indicator with Skeleton
                    if (provider.isLoading)
                      const WeatherSkeleton(),

                    // Error Message
                    if (provider.error != null)
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: theme.colorScheme.errorContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.error_outline_rounded,
                                  color: theme.colorScheme.error,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  provider.error!,
                                  style: TextStyle(
                                    color: theme.colorScheme.onErrorContainer,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
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
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: BorderSide(
                            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                          ),
                        ),
                        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.wb_sunny_rounded,
                                  size: 64,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                strings.welcome,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                strings.welcomeMessage,
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
      // Save to search history
      _saveSearchHistory(q);
    }
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
                stops: const [0.3, 1.0],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.wb_sunny_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.appTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.weatherApp,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.home_rounded, color: Colors.white, size: 20),
              ),
              title: Text(
                strings.home,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          const SizedBox(height: 8),

          // New Features Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '⚡ Tính năng',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          _buildDrawerItem(
            context,
            icon: Icons.favorite_rounded,
            title: 'Yêu thích',
            subtitle: '${_favoriteCities.length} thành phố',
            gradient: [Colors.pink, Colors.pinkAccent],
            onTap: () {
              Navigator.pop(context);
              _showFavoritesDialog(context);
            },
          ),

          _buildDrawerItem(
            context,
            icon: Icons.history_rounded,
            title: 'Lịch sử tìm kiếm',
            subtitle: '${_searchHistory.length} tìm kiếm',
            gradient: [Colors.purple, Colors.purpleAccent],
            onTap: () {
              Navigator.pop(context);
              _showSearchHistoryDialog(context);
            },
          ),

          _buildDrawerItem(
            context,
            icon: Icons.compare_arrows_rounded,
            title: 'So sánh thời tiết',
            subtitle: '${_compareList.length}/2 thành phố',
            gradient: [Colors.blue, Colors.lightBlueAccent],
            onTap: () {
              Navigator.pop(context);
              _showCompareWeatherDialog(context);
            },
          ),

          _buildDrawerItem(
            context,
            icon: Icons.notifications_active_rounded,
            title: 'Cảnh báo thời tiết',
            subtitle: 'Nhận thông báo',
            gradient: [Colors.orange, Colors.deepOrangeAccent],
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tính năng đang phát triển...')),
              );
            },
          ),

          const SizedBox(height: 8),
          const Divider(),

          // Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'ℹ️ Thông tin',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.group_rounded, color: theme.colorScheme.primary),
            title: Text(strings.developer),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.pop(context);
              _showDevelopersDialog(context);
            },
          ),

          ListTile(
            leading: Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary),
            title: Text(strings.about),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),

          const Divider(),

          // Settings Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '⚙️ Cài đặt',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.language_rounded, color: theme.colorScheme.primary),
            title: Text(strings.language),
            subtitle: Text(
              Provider.of<LocaleProvider>(context).locale.languageCode == 'vi' 
                ? strings.vietnamese 
                : strings.english,
              style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.pop(context);
              _showLanguageDialog(context);
            },
          ),

          ListTile(
            leading: Icon(Icons.dark_mode_rounded, color: theme.colorScheme.primary),
            title: const Text('Chế độ tối'),
            subtitle: const Text('Dark mode'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng đang phát triển...')),
                );
              },
            ),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.star_rounded, color: Colors.amber),
            title: Text(strings.rateApp),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(strings.thankYou)),
              );
            },
          ),

          const Divider(),

          // Version
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Version 1.1.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Load search history from SharedPreferences
  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    setState(() {
      _searchHistory = history;
    });
  }

  // Save search history to SharedPreferences
  Future<void> _saveSearchHistory(String city) async {
    if (city.trim().isEmpty) return;
    
    // Remove if already exists (to move to top)
    _searchHistory.remove(city);
    // Add to the beginning
    _searchHistory.insert(0, city);
    // Keep only last 10 items
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
    setState(() {});
  }

  // Clear all search history
  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() {
      _searchHistory = [];
    });
  }

  // Helper method to build modern drawer items
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 12,
                ),
              )
            : null,
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }

  void _showFavoritesDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.pink, Colors.pinkAccent],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('⭐ Thành phố yêu thích'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _favoriteCities.length,
            itemBuilder: (context, index) {
              final city = _favoriteCities[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer.withOpacity(0.3),
                      theme.colorScheme.secondaryContainer.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.location_city_rounded),
                  title: Text(
                    city,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.search_rounded),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      setState(() {
                        _controller.text = city;
                      });
                      // Tự động tìm kiếm
                      final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
                      weatherProvider.loadByCity(city);
                      _saveSearchHistory(city);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showSearchHistoryDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.purpleAccent],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.history_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('🕐 Lịch sử tìm kiếm'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: _searchHistory.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_outlined,
                        size: 64,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có lịch sử tìm kiếm',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchHistory.length,
                  itemBuilder: (context, index) {
                    final city = _searchHistory[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primaryContainer.withOpacity(0.3),
                            theme.colorScheme.tertiaryContainer.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.3),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[700],
                            ),
                          ),
                        ),
                        title: Text(
                          city,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Tìm kiếm gần đây',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.search_rounded),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            setState(() {
                              _controller.text = city;
                            });
                            // Tự động tìm kiếm
                            final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
                            weatherProvider.loadByCity(city);
                            _saveSearchHistory(city);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          if (_searchHistory.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                _clearSearchHistory();
                Navigator.pop(dialogContext);
              },
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Xóa tất cả'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showCompareWeatherDialog(BuildContext context) {
    final theme = Theme.of(context);
    String selectedCountry1 = 'VN';
    String? selectedCity1;
    String selectedCountry2 = 'VN';
    String? selectedCity2;
    
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.compare_arrows_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Text('⚖️ So sánh thời tiết')),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Thành phố 1
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.1),
                            Colors.lightBlue.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Thành phố thứ nhất',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Country dropdown 1
                          DropdownButtonFormField<String>(
                            value: selectedCountry1,
                            decoration: InputDecoration(
                              labelText: 'Quốc gia',
                              prefixIcon: const Icon(Icons.flag_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            items: _countries.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value, style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedCountry1 = value!;
                                selectedCity1 = _allCities[selectedCountry1]?.first;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // City dropdown 1
                          DropdownButtonFormField<String>(
                            value: selectedCity1 ?? _allCities[selectedCountry1]?.first,
                            decoration: InputDecoration(
                              labelText: 'Thành phố',
                              prefixIcon: const Icon(Icons.location_city_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            items: _allCities[selectedCountry1]?.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(city, style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedCity1 = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Icon so sánh
                    Icon(
                      Icons.compare_arrows_rounded,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Thành phố 2
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.1),
                            Colors.lightGreen.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '2',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Thành phố thứ hai',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Country dropdown 2
                          DropdownButtonFormField<String>(
                            value: selectedCountry2,
                            decoration: InputDecoration(
                              labelText: 'Quốc gia',
                              prefixIcon: const Icon(Icons.flag_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            items: _countries.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value, style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedCountry2 = value!;
                                selectedCity2 = _allCities[selectedCountry2]?.first;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // City dropdown 2
                          DropdownButtonFormField<String>(
                            value: selectedCity2 ?? _allCities[selectedCountry2]?.first,
                            decoration: InputDecoration(
                              labelText: 'Thành phố',
                              prefixIcon: const Icon(Icons.location_city_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            items: _allCities[selectedCountry2]?.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(city, style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedCity2 = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Hủy'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final city1 = selectedCity1 ?? _allCities[selectedCountry1]?.first;
                  final city2 = selectedCity2 ?? _allCities[selectedCountry2]?.first;
                  
                  if (city1 != null && city2 != null) {
                    Navigator.pop(dialogContext);
                    // Thêm country code giống như trang chủ
                    final query1 = '$city1,${selectedCountry1.toLowerCase()}';
                    final query2 = '$city2,${selectedCountry2.toLowerCase()}';
                    _showCompareResultDialog(context, query1, query2, city1, city2);
                  }
                },
                icon: const Icon(Icons.compare_rounded),
                label: const Text('So sánh'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCompareResultDialog(BuildContext context, String query1, String query2, String displayCity1, String displayCity2) async {
    final theme = Theme.of(context);
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Đang tải dữ liệu...', style: TextStyle(color: theme.colorScheme.onSurface)),
          ],
        ),
      ),
    );
    
    // Fetch data
    Weather? weather1;
    Weather? weather2;
    String? error;
    
    try {
      print('Fetching weather for: $query1');
      weather1 = await WeatherApi(apiKey: '75b033222e4e5b2c9f5ee5ac7903b933').fetchByCity(query1);
      print('Got weather1: ${weather1.city}, ${weather1.tempC}°C');
    } catch (e) {
      print('Error fetching weather1: $e');
      error = e.toString();
      weather1 = Weather(
        city: displayCity1,
        country: 'N/A',
        tempC: 0,
        description: 'Lỗi: Không tìm thấy',
        icon: '01d',
        humidity: 0,
        windMs: 0,
        time: DateTime.now(),
      );
    }
    
    try {
      print('Fetching weather for: $query2');
      weather2 = await WeatherApi(apiKey: '75b033222e4e5b2c9f5ee5ac7903b933').fetchByCity(query2);
      print('Got weather2: ${weather2.city}, ${weather2.tempC}°C');
    } catch (e) {
      print('Error fetching weather2: $e');
      error = e.toString();
      weather2 = Weather(
        city: displayCity2,
        country: 'N/A',
        tempC: 0,
        description: 'Lỗi: Không tìm thấy',
        icon: '01d',
        humidity: 0,
        windMs: 0,
        time: DateTime.now(),
      );
    }
    
    // Update state (sử dụng displayCity cho key)
    setState(() {
      _compareList = [displayCity1, displayCity2];
      _compareWeatherData = {
        displayCity1: weather1,
        displayCity2: weather2,
      };
    });
    
    print('Compare data updated: ${_compareWeatherData.keys}');
    
    // Close loading dialog
    if (context.mounted) {
      Navigator.pop(context);
    }
    
    // Show error if any
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lưu ý: Có lỗi khi tải dữ liệu'),
          backgroundColor: Colors.orange,
        ),
      );
    }
    
    // Show result dialog
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.assessment_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('📊 Kết quả so sánh')),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView(
              children: [
                // Header row
                _buildCompareHeaderRow(theme),
                const Divider(),
                
                // Data rows
                ..._buildCompareDataRows(theme),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Đóng'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showCompareWeatherDialog(context);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('So sánh khác'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCompareHeaderRow(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 100, child: Text('')), // Empty for label column
          ..._compareList.map((city) => Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      city,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _compareList.remove(city);
                        _compareWeatherData.remove(city);
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  List<Widget> _buildCompareDataRows(ThemeData theme) {
    return [
      _buildCompareRow('🌡️ Nhiệt độ', (weather) => '${weather.tempC.round()}°C', theme),
      _buildCompareRow('💧 Độ ẩm', (weather) => '${weather.humidity}%', theme),
      _buildCompareRow('💨 Gió', (weather) => '${weather.windMs.toStringAsFixed(1)} m/s', theme),
      _buildCompareRow('☁️ Mô tả', (weather) => weather.description, theme),
      _buildCompareRow('� Quốc gia', (weather) => weather.country, theme),
      _buildCompareRow('🕐 Thời gian', (weather) => _formatDateTime(weather.time), theme),
    ];
  }

  Widget _buildCompareRow(String label, String Function(Weather) getValue, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          ..._compareList.map((city) {
            final weather = _compareWeatherData[city];
            return Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: weather == null
                  ? const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Text(
                      getValue(weather),
                      style: const TextStyle(fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showDevelopersDialog(BuildContext context) {
    final strings = S.of(context); // Lấy strings TRƯỚC khi showDialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.group),
            const SizedBox(width: 8),
            Text(strings.developer),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.teamName,
                style: Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(strings.className),
              const SizedBox(height: 4),
              Text(strings.year),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildDeveloperInfo(strings.members, [
                strings.memberDat,
              ]),
              const SizedBox(height: 16),
              _buildDeveloperInfo(strings.technology, [
                'Flutter 3.9.2+',
                'Dart',
                'OpenWeatherMap API',
                'Material Design 3',
              ]),
              const SizedBox(height: 16),
              _buildDeveloperInfo(strings.contact, [
                strings.email,
                strings.github,
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(strings.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperInfo(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Row(
            children: [
              const Text('• '),
              Expanded(child: Text(item)),
            ],
          ),
        )),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    final strings = S.of(context); // Lấy strings TRƯỚC khi showDialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 8),
            Text(strings.about),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.wb_sunny,
                  size: 64,
                  color: Theme.of(dialogContext).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                strings.appTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${strings.version} 1.1.0',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                strings.modernWeatherApp,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                strings.appDescription,
              ),
              const SizedBox(height: 16),
              Text(
                strings.features,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...[
                strings.feature1,
                strings.feature2,
                strings.feature3,
                strings.feature4,
                strings.feature5,
              ].map((item) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Text(item),
              )),
              const SizedBox(height: 16),
              Text(
                strings.copyright,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(strings.close),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final strings = S.of(context); // Lấy strings TRƯỚC khi showDialog
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale.languageCode;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.language),
            const SizedBox(width: 8),
            Text(strings.selectLanguage),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('🇻🇳 ${strings.vietnamese}'),
              value: 'vi',
              groupValue: currentLocale,
              onChanged: (value) {
                if (value != null) {
                  localeProvider.setLocale(Locale(value));
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(strings.changedToVietnamese),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            RadioListTile<String>(
              title: Text('🇬🇧 ${strings.english}'),
              value: 'en',
              groupValue: currentLocale,
              onChanged: (value) {
                if (value != null) {
                  localeProvider.setLocale(Locale(value));
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(strings.changedToEnglish),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(strings.cancel),
          ),
        ],
      ),
    );
  }
}