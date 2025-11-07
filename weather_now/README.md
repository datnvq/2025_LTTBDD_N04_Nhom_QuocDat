# Weather Now - Ứng dụng Thời Tiết Thông Minh ☀️🌧️

Ứng dụng xem thời tiết đa nền tảng được phát triển bằng Flutter, sử dụng OpenWeatherMap API với giao diện hiện đại và nhiều tính năng tiện ích.

## ✨ Tính năng Nổi Bật

### 🌍 Tìm Kiếm Thời Tiết Toàn Cầu
- **10 quốc gia/khu vực** được tích hợp sẵn
- **Hàng trăm thành phố** có sẵn cho mỗi quốc gia
- **Tìm kiếm thông minh** - Tự động match với quốc gia đã chọn
- **Quick Access Chips** - Nhanh chóng truy cập thành phố phổ biến
- � **GPS Location** - Lấy thời tiết vị trí hiện tại tự động

### 🌡️ Thông Tin Thời Tiết Chi Tiết
- ☀️ Nhiệt độ hiện tại (°C)
- 🌈 Mô tả tình trạng thời tiết
- 💧 Độ ẩm không khí
- 💨 Tốc độ gió (m/s)
- 🌡️ Cảm giác nhiệt độ (Feels like)
- 🕐 Thời gian cập nhật
- 🎨 Icon động theo thời tiết

### ⭐ Quản Lý Yêu Thích (Favorites)
- ❤️ Lưu các thành phố yêu thích
- 📌 Truy cập nhanh từ menu drawer
- 🔍 Tìm kiếm trực tiếp từ danh sách
- 🗑️ Xóa khỏi danh sách dễ dàng
- 💾 Tự động lưu vào SharedPreferences

### 🕐 Lịch Sử Tìm Kiếm (Search History)
- 📝 Lưu 10 tìm kiếm gần nhất
- ⚡ Tìm kiếm lại nhanh chóng
- 🗑️ Xóa từng mục hoặc xóa tất cả
- 📊 Hiển thị theo thứ tự thời gian

### 🔔 Cảnh Báo Thời Tiết (Weather Alerts)
- 🔥 **Nhiệt độ cao** - Cảnh báo khi vượt ngưỡng
- ❄️ **Nhiệt độ thấp** - Cảnh báo khi dưới ngưỡng
- 💧 **Độ ẩm cao** - Cảnh báo môi trường ẩm ướt
- 💨 **Gió mạnh** - Cảnh báo gió nguy hiểm
- ⚙️ **Tùy chỉnh ngưỡng** - Điều chỉnh theo nhu cầu
- 🔕 **Bật/tắt** cảnh báo linh hoạt

### 🌐 Đa Ngôn Ngữ (Multi-language)
- 🇻🇳 **Tiếng Việt** - Hỗ trợ đầy đủ
- 🇬🇧 **English** - Full support
- 🔄 **Chuyển đổi ngay lập tức** - Không cần restart
- 📱 **Toàn bộ giao diện** được dịch
- 💬 **Thông báo & Dialogs** đa ngôn ngữ

### 🎨 Giao Diện & Trải Nghiệm
- 🌙 **Dark Mode** - Chế độ tối bảo vệ mắt
- ✨ **Material Design 3** - Thiết kế hiện đại
- 🎭 **Gradient Backgrounds** - Nền gradient đẹp mắt
- 🎬 **Smooth Animations** - Chuyển động mượt mà
- ⚡ **Skeleton Loading** - Loading UX tốt hơn
- 📱 **Responsive Design** - Tương thích mọi màn hình
- 🖼️ **Modern Cards** - Card design đẹp với shadow & border

## 🚀 Cài đặt và Chạy

### Yêu cầu
- Flutter SDK (phiên bản >=3.9.2)
- Android Studio / VS Code
- Thiết bị Android hoặc Emulator

### Các bước thực hiện

1. **Clone repository:**
```bash
git clone <repository-url>
cd weather_now
```

2. **Cài đặt dependencies:**
```bash
flutter pub get
```

3. **Lấy API Key từ OpenWeatherMap:**
   - Truy cập: https://openweathermap.org/api
   - Đăng ký tài khoản miễn phí
   - Vào phần API Keys và copy key của bạn

4. **Cấu hình API Key:**
   - Mở file `lib/main.dart`
   - Thay thế `YOUR_OPENWEATHER_API_KEY` bằng API key của bạn:
   ```dart
   const apiKey = 'your_actual_api_key_here';
   ```

5. **Chạy ứng dụng:**
```bash
# Kiểm tra thiết bị đã kết nối
flutter devices

# Chạy trên thiết bị/emulator
flutter run
```

## 📦 Dependencies Chính

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # HTTP Client
  http: ^1.5.0                    # API calls
  
  # Location Services  
  geolocator: ^14.0.2             # GPS positioning
  
  # State Management
  provider: ^6.1.5+1              # Provider pattern
  
  # Utilities
  intl: ^0.20.2                   # Date/time formatting
  shared_preferences: ^2.3.4      # Local storage (favorites, history)
```

### Vai Trò Từng Package

| Package | Mục Đích | Sử Dụng Trong |
|---------|----------|---------------|
| `http` | Gọi OpenWeatherMap API | `weather_api.dart` |
| `geolocator` | Lấy tọa độ GPS | `home_screen.dart` |
| `provider` | Quản lý state đa màn hình | `weather_provider.dart`, `locale_provider.dart` |
| `intl` | Format thời gian, đa ngôn ngữ | Toàn bộ UI |
| `shared_preferences` | Lưu favorites, history | `favorites_screen.dart`, `search_history_screen.dart` |

## 🏗️ Cấu Trúc Dự Án

```
lib/
├── main.dart                          # 🚀 Entry point + Theme + Providers
│
├── models/                            # 📊 Data Models
│   └── weather.dart                   # Weather data model
│
├── providers/                         # 🔄 State Management
│   ├── weather_provider.dart          # Weather state (temp, humidity, etc.)
│   └── locale_provider.dart           # Language state (vi/en)
│
├── screens/                           # 📱 UI Screens
│   ├── home_screen.dart               # Main screen (search, display)
│   ├── favorites_screen.dart          # ❤️ Favorite cities list
│   ├── search_history_screen.dart     # 🕐 Recent searches
│   └── weather_alerts_screen.dart     # 🔔 Alert configuration
│
├── services/                          # 🌐 External Services
│   └── weather_api.dart               # OpenWeatherMap API client
│
├── widgets/                           # 🎨 Reusable Widgets
│   ├── weather_card.dart              # Weather info card
│   ├── weather_skeleton.dart          # Loading skeleton
│   └── language_selector.dart         # Language switcher
│
├── utils/                             # 🛠️ Utilities
│   └── app_strings.dart               # 🌐 Localization strings (vi/en)
│
└── l10n/                              # 🌍 Localization Files
    ├── app_en.arb                     # English strings
    └── app_vi.arb                     # Vietnamese strings
```

### Luồng Dữ Liệu (Data Flow)

```
User Input (home_screen.dart)
      ↓
Weather Provider (weather_provider.dart)
      ↓
Weather API Service (weather_api.dart)
      ↓
HTTP Request → OpenWeatherMap API
      ↓
JSON Response
      ↓
Weather Model (weather.dart)
      ↓
Provider notifies listeners
      ↓
UI Updates (weather_card.dart)
```

## 📱 Hướng Dẫn Sử Dụng Chi Tiết

### 🔍 Tìm Kiếm Thời Tiết

**Cách 1: Sử dụng Quick Access**
1. Mở app → Nhìn vào phần "Popular Cities"
2. Tap vào chip của thành phố bạn muốn
3. Thời tiết hiển thị ngay lập tức

**Cách 2: Tìm kiếm thủ công**
1. Chọn **quốc gia** từ dropdown (10 quốc gia)
2. Nhập **tên thành phố** vào ô tìm kiếm
3. Nhấn nút 🔍 hoặc phím **Enter**

**Cách 3: GPS Location**
1. Nhấn nút **📍 Location** trên toolbar
2. Cho phép quyền truy cập vị trí
3. Thời tiết vị trí hiện tại tự động hiển thị

### ⭐ Quản Lý Yêu Thích

**Thêm vào Favorites:**
1. Tìm kiếm thành phố bất kỳ
2. Nhấn nút ⭐ **Add Favorite** trên weather card
3. Thông báo xác nhận "Added [City] to favorites"

**Xem Favorites:**
1. Mở **Menu Drawer** (☰ trên góc trái)
2. Chọn **❤️ Favorite Cities**
3. Danh sách thành phố yêu thích hiển thị

**Xóa khỏi Favorites:**
1. Trong danh sách Favorites
2. Nhấn nút **🗑️ Delete** bên cạnh thành phố
3. Hoặc tìm kiếm thành phố đó và nhấn **❤️ Favorited**

### 🕐 Sử dụng Search History

**Xem lịch sử:**
1. Mở **Menu Drawer**
2. Chọn **🕐 Search History**
3. 10 tìm kiếm gần nhất hiển thị

**Tìm lại nhanh:**
1. Tap vào bất kỳ mục lịch sử nào
2. App tự động tìm kiếm thành phố đó

**Xóa lịch sử:**
- **Xóa 1 mục**: Nhấn 🗑️ bên cạnh
- **Xóa tất cả**: Nhấn "Delete All" ở cuối danh sách

### 🔔 Cấu Hình Weather Alerts

**Bật/Tắt Alerts:**
1. Mở **Menu Drawer**
2. Chọn **🔔 Weather Alerts**
3. Toggle switch để **Enable/Disable**

**Tùy chỉnh ngưỡng:**
- **🔥 High Temp**: Cảnh báo khi > X°C (mặc định 35°C)
- **❄️ Low Temp**: Cảnh báo khi < X°C (mặc định 5°C)
- **💧 High Humidity**: Cảnh báo khi > X% (mặc định 80%)
- **💨 High Wind**: Cảnh báo khi > X m/s (mặc định 15 m/s)

**Cách hoạt động:**
- Khi tìm kiếm thời tiết, nếu vượt ngưỡng → Alert dialog hiển thị
- Màu đỏ cho nhiệt độ cao, xanh cho nhiệt độ thấp
- Icon tương ứng với loại cảnh báo

### 🌐 Chuyển Đổi Ngôn Ngữ

**Cách chuyển:**
1. Mở **Menu Drawer**
2. Chọn **🌐 Language**
3. Chọn **🇻🇳 Tiếng Việt** hoặc **🇬🇧 English**
4. Giao diện chuyển ngay lập tức

**Nội dung được dịch:**
- Tất cả menu & buttons
- Thông báo & dialogs
- Mô tả thời tiết
- Tên quốc gia
- Error messages

### 🌙 Chế Độ Tối (Dark Mode)

**Tự động theo hệ thống:**
- App tự động detect Dark Mode của thiết bị
- Android: Settings → Display → Dark theme
- iOS: Settings → Display & Brightness → Dark

**Lợi ích:**
- Bảo vệ mắt khi dùng ban đêm
- Tiết kiệm pin (OLED screens)
- Giao diện đẹp mắt với gradient tối

## 🔐 Quyền Ứng Dụng (Permissions)

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>App needs your location to show weather at your current position</string>
```

### Chi Tiết Quyền

| Quyền | Mục Đích | Bắt Buộc |
|-------|----------|----------|
| `INTERNET` | Gọi OpenWeatherMap API | ✅ Có |
| `ACCESS_FINE_LOCATION` | GPS chính xác (± 10m) | ⚠️ Tùy chọn |
| `ACCESS_COARSE_LOCATION` | GPS gần đúng (± 100m) | ⚠️ Tùy chọn |

**Lưu ý:** App vẫn hoạt động bình thường nếu từ chối quyền location (chỉ mất tính năng GPS).

## 🌍 Quốc Gia & Thành Phố Hỗ Trợ

App hỗ trợ 10 quốc gia với danh sách thành phố phổ biến:

- 🇻🇳 **Việt Nam**: Hà Nội, Hồ Chí Minh, Đà Nẵng, Hải Phòng, Nha Trang
- 🇺🇸 **Hoa Kỳ**: New York, Los Angeles, Chicago, Houston, Miami
- 🇬🇧 **Anh**: London, Manchester, Birmingham, Liverpool, Edinburgh
- 🇯🇵 **Nhật Bản**: Tokyo, Osaka, Kyoto, Yokohama, Nagoya
- 🇰🇷 **Hàn Quốc**: Seoul, Busan, Incheon, Daegu, Gwangju
- 🇨🇳 **Trung Quốc**: Beijing, Shanghai, Guangzhou, Shenzhen, Chengdu
- 🇹🇭 **Thái Lan**: Bangkok, Chiang Mai, Phuket, Pattaya, Krabi
- 🇸🇬 **Singapore**: Singapore
- 🇫🇷 **Pháp**: Paris, Marseille, Lyon, Toulouse, Nice
- 🇩🇪 **Đức**: Berlin, Munich, Hamburg, Frankfurt, Cologne

*Lưu ý: Bạn có thể tìm kiếm bất kỳ thành phố nào trên thế giới, không chỉ giới hạn trong danh sách trên.*

## 🎨 Screenshots

> *Coming soon - Sẽ cập nhật screenshots của ứng dụng*

## 🚀 Build & Deploy

### Build APK cho Android

**1. Debug APK (Để Test)**
```bash
flutter build apk --debug

# APK location: build/app/outputs/flutter-apk/app-debug.apk
# Size: ~40-50 MB
# Use: Development & testing only
```

**2. Release APK (Để Phát Hành)**
```bash
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
# Size: ~15-20 MB (optimized)
# Use: Production deployment
```

**3. Split APKs (Tối Ưu Kích Thước)**
```bash
flutter build apk --split-per-abi

# Tạo 3 APK cho từng architecture:
# - app-armeabi-v7a-release.apk (~12 MB) - Older devices
# - app-arm64-v8a-release.apk (~14 MB) - Modern devices
# - app-x86_64-release.apk (~16 MB) - Emulators/Chromebooks
```

### Build iOS App

```bash
flutter build ios --release

# Yêu cầu: Xcode, Apple Developer Account
# Output: build/ios/iphoneos/Runner.app
```

### Build cho Web

```bash
flutter build web --release

# Output: build/web/
# Deploy to: Firebase Hosting, Netlify, Vercel, etc.
```

### Chạy Profile Mode (Test Performance)

```bash
flutter run --profile

# Between debug & release
# Good for: Performance testing, profiling
```

## 🔧 Troubleshooting & FAQ

### ❌ Lỗi Thường Gặp

**1. API 401 - Unauthorized**
```
Error: API key invalid or unauthorized
```
**Giải pháp:**
- Kiểm tra lại API key trong `lib/services/weather_api.dart`
- API key mới cần **10-120 phút** để kích hoạt
- Tạo API key mới tại [OpenWeatherMap](https://openweathermap.org/api)
- Đảm bảo không có khoảng trắng trong key

**2. GPS Không Hoạt Động**
```
Location permission denied
```
**Giải pháp:**
- Bật **GPS/Location Services** trên thiết bị
- Settings → Apps → Weather Now → Permissions → Location → Allow
- Trên **Web Browser**, GPS có thể không chính xác
- Thử restart app sau khi cấp quyền

**3. App Chạy Chậm/Lag**
```
Performance issues in debug mode
```
**Giải pháp:**
- Debug mode luôn chậm hơn release 10-20x
- Build **Release APK**: `flutter build apk --release`
- Hoặc chạy profile mode: `flutter run --profile`
- Disable debug banner: `debugShowCheckedModeBanner: false`

**4. Không Tìm Thấy Thành Phố**
```
City not found (404)
```
**Giải pháp:**
- Kiểm tra **đúng quốc gia** đã chọn
- Thử tên thành phố bằng **tiếng Anh** (ví dụ: "Ho Chi Minh" thay vì "Hồ Chí Minh")
- Tìm kiếm chính xác: "Hanoi" thay vì "Ha Noi"
- Thử thành phố lớn trước để test API

**5. Favorites/History Không Lưu**
```
Data not persisted after app restart
```
**Giải pháp:**
- Kiểm tra quyền **Storage** của app
- Clear app data: Settings → Apps → Weather Now → Storage → Clear Data
- Reinstall app nếu vẫn lỗi
- Check `shared_preferences` package đã cài đúng: `flutter pub get`

**6. Lỗi Build APK**
```
Build failed with Gradle errors
```
**Giải pháp:**
- Clean project: `flutter clean`
- Get dependencies: `flutter pub get`
- Update Flutter: `flutter upgrade`
- Check Java/JDK version: Java 11 hoặc 17

### 🤔 Câu Hỏi Thường Gặp (FAQ)

**Q: App có miễn phí không?**  
A: Hoàn toàn miễn phí! OpenWeatherMap API cung cấp 1000 calls/ngày miễn phí.

**Q: Có thể offline không?**  
A: Không, app cần Internet để gọi API. Có thể cache data trong tương lai.

**Q: Hỗ trợ những nền tảng nào?**  
A: Android, iOS, Web, Windows, macOS, Linux (Flutter đa nền tảng).

**Q: Làm sao để đóng góp code?**  
A: Fork repo → Tạo branch → Commit changes → Open Pull Request.

**Q: Tại sao không dùng flutter_localizations?**  
A: Project sử dụng custom `AppStrings` class để dễ quản lý và mở rộng.

**Q: Alert notification có push không?**  
A: Hiện tại chỉ hiển thị dialog khi tìm kiếm. Push notification sẽ có trong phiên bản sau.

## 📚 Tech Stack

- **Framework**: Flutter 3.9.2+
- **Language**: Dart
- **State Management**: Provider
- **API**: OpenWeatherMap API
- **Architecture**: Clean Architecture (MVVM-like)
- **Design**: Material Design 3

## 🔄 Version History & Changelog

### 📌 v2.0.0 - Multi-feature Update (Current)
**Release Date:** 2025-01

**🎉 Major Features:**
- ⭐ **Favorites System** - Save and manage favorite cities
- 🕐 **Search History** - Track last 10 searches
- 🔔 **Weather Alerts** - Configurable threshold alerts
- 🌐 **Multi-language** - Vietnamese & English support
- 🎨 **Enhanced UI** - Modern Material Design 3

**✨ New Features:**
- Drawer menu với 4 sections
- SharedPreferences integration
- Alert threshold configuration
- Instant language switching
- Delete all history function

**🔧 Improvements:**
- Better error handling
- Improved loading states
- Responsive design optimization
- Code refactoring & cleanup

**🐛 Bug Fixes:**
- Fixed GPS permission handling
- Fixed API error messages
- Fixed dark mode color scheme

---

### 📌 v1.1.0 - Country & Popular Cities
**Release Date:** 2024-12

**✨ Features Added:**
- 🌍 Country/Region selector (10 countries)
- 🏙️ Popular cities quick access
- ⚡ Skeleton loading animation
- 🌙 Dark mode support
- 🎨 Gradient backgrounds

**🔧 Improvements:**
- Enhanced weather card UI
- Better search UX
- Improved error messages

---

### 📌 v1.0.0 - Initial Release
**Release Date:** 2024-11

**🚀 Core Features:**
- 🔍 Basic weather search
- 📍 GPS location support
- 🌡️ Temperature, humidity, wind display
- 🎨 Material Design UI
- 📱 Responsive layout

---

## 🗺️ Roadmap & Future Plans

### 🎯 v2.1.0 - Planned Features
- [ ] 📊 **7-day forecast** - Dự báo 7 ngày
- [ ] 📈 **Hourly forecast** - Dự báo theo giờ
- [ ] 🔔 **Push notifications** - Thông báo push
- [ ] 🌡️ **Temperature charts** - Biểu đồ nhiệt độ
- [ ] 🗺️ **Weather map** - Bản đồ thời tiết

### 🎯 v3.0.0 - Future Ideas
- [ ] 🤖 **AI Weather predictions** - Dự đoán AI
- [ ] 🌈 **Widget support** - Home screen widget
- [ ] 👤 **User accounts** - Đăng nhập/đồng bộ
- [ ] 📸 **Weather photos** - Chia sẻ ảnh thời tiết
- [ ] 🎙️ **Voice commands** - Điều khiển bằng giọng nói
- ✨ Enhanced weather card design
- 🎨 Gradient backgrounds
- 🐛 Improved search accuracy

### v1.0.0
- 🎉 Initial release
- 🌡️ Basic weather display
- 📍 GPS location support
- 🔍 City search

## �📝 License

This project is open source and available under the MIT License.

## 👥 Nhóm Phát Triển & License

### 🎓 Team Members
**Nhóm QuocDat - LTTBDD N04 - 2025**

- Lead Developer & Architecture
- UI/UX Designer
- Backend Integration
- Testing & QA

### 🤝 Contributing

Contributions are welcome! To contribute:
1. Fork the repository
2. Create your branch: `git checkout -b feature/AmazingFeature`
3. Commit changes: `git commit -m 'Add AmazingFeature'`
4. Push to branch: `git push origin feature/AmazingFeature`
5. Open a Pull Request

### 📄 License

This project is licensed under the **MIT License** - see [LICENSE](LICENSE) for details.

### 🌟 Credits

**Powered by:**
- [OpenWeatherMap API](https://openweathermap.org/) - Weather data
- [Flutter](https://flutter.dev/) - Framework
- [Material Design 3](https://m3.material.io/) - Design system

---

<div align="center">

### ⭐ If you like this project, give it a star! ⭐

**Made with ❤️ using Flutter**

**Nhóm QuocDat - LTTBDD N04 - 2025**

[⬆ Back to Top](#weather-now---ứng-dụng-thời-tiết-thông-minh-️)

</div>


