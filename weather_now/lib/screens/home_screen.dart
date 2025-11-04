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
  String? _selectedCity;

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
  }

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
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    tooltip: 'Menu',
                  ),
                ),
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
                                  hint: const Text('Chọn quốc gia'),
                                  items: _countries.entries.map((entry) {
                                    return DropdownMenuItem(
                                      value: entry.key,
                                      child: Text(entry.value),
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
                            const SizedBox(height: 12),

                            // City Dropdown Selector
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
                                  value: _selectedCity,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  hint: const Text('Chọn tỉnh/thành phố'),
                                  items: _allCities[_selectedCountry]?.map((city) {
                                    return DropdownMenuItem(
                                      value: city,
                                      child: Text(city),
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
                            const SizedBox(height: 12),

                            // City Input (có thể nhập tay)
                            TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                labelText: 'Hoặc nhập tên thành phố',
                                hintText: 'Nhập tên thành phố...',
                                prefixIcon: const Icon(Icons.edit_location),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                              ),
                              onSubmitted: (_) => _searchCity(provider),
                              onChanged: (value) {
                                // Sync với dropdown nếu trùng
                                if (_allCities[_selectedCountry]?.contains(value) ?? false) {
                                  setState(() {
                                    _selectedCity = value;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            // Popular Cities Chips (Thành phố nổi bật)
                            if (_popularCities[_selectedCountry] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Thành phố nổi bật',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _popularCities[_selectedCountry]!
                                        .map((city) => ActionChip(
                                              label: Text(city),
                                              avatar: const Icon(Icons.location_on, size: 16),
                                              onPressed: () {
                                                setState(() {
                                                  _selectedCity = city;
                                                  _controller.text = city;
                                                });
                                                _searchCity(provider);
                                              },
                                            ))
                                        .toList(),
                                  ),
                                ],
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

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    
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
                  theme.colorScheme.secondary,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  'Weather Now',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ứng dụng thời tiết',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          // Thông tin nhà phát triển
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Nhà phát triển'),
            onTap: () {
              Navigator.pop(context);
              _showDevelopersDialog(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Về ứng dụng'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),

          const Divider(),

          // Settings
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Cài đặt'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tính năng đang phát triển...')),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.star_outline),
            title: const Text('Đánh giá ứng dụng'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cảm ơn bạn đã quan tâm!')),
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

  void _showDevelopersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.group),
            SizedBox(width: 8),
            Text('Nhà phát triển'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nhóm Nguyen Vo Quoc Dat',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Lớp: LTTBDD N04'),
              const SizedBox(height: 4),
              const Text('Năm: 2025'),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildDeveloperInfo('👨‍💻 Thành viên:', [
                'Nguyễn Võ Quôc Đạt - MSSV: 23010306',
              ]),
              const SizedBox(height: 16),
              _buildDeveloperInfo('🛠️ Công nghệ:', [
                'Flutter 3.9.2+',
                'Dart',
                'OpenWeatherMap API',
                'Material Design 3',
              ]),
              const SizedBox(height: 16),
              _buildDeveloperInfo('📧 Liên hệ:', [
                'Email: 23010306@st.phenikaa-uni.edu.vn',
                'GitHub: github.com/datnvq',
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline),
            SizedBox(width: 8),
            Text('Về Weather Now'),
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
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Weather Now',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Version 1.1.0',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                '📱 Ứng dụng thời tiết hiện đại',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Weather Now cung cấp thông tin thời tiết chính xác và cập nhật cho hơn 200,000 thành phố trên toàn thế giới.',
              ),
              const SizedBox(height: 16),
              const Text(
                '✨ Tính năng nổi bật:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...[
                '• Tìm kiếm theo quốc gia và thành phố',
                '• Thời tiết vị trí hiện tại (GPS)',
                '• Giao diện đẹp với Dark Mode',
                '• Hỗ trợ 10 quốc gia phổ biến',
                '• Dữ liệu real-time từ OpenWeatherMap',
              ].map((item) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Text(item),
              )),
              const SizedBox(height: 16),
              const Text(
                '© 2025 Nhóm NguyenVoQuocDat - LTTBDD N04',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}