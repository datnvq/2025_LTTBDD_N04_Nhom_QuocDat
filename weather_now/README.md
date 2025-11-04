# Weather Now - Ứng dụng xem thời tiết thực

Ứng dụng Android Flutter để xem thông tin thời tiết thực tế sử dụng OpenWeatherMap API.

## ✨ Tính năng

- 🌍 **Chọn quốc gia/khu vực** để tìm kiếm chính xác hơn (10 quốc gia)
- 🏙️ **Thành phố phổ biến** - Quick access chips cho các thành phố hot
- 🔍 **Tìm kiếm thời tiết theo tên thành phố**
- 📍 **Lấy thời tiết vị trí hiện tại** (sử dụng GPS)
- 🌡️ **Hiển thị thông tin chi tiết:**
  - Nhiệt độ (°C)
  - Mô tả thời tiết
  - Độ ẩm
  - Tốc độ gió
  - Cảm giác nhiệt độ
  - Tình trạng thời tiết
  - Icon thời tiết động
- 🎨 **Giao diện đẹp với Material Design 3**
  - Gradient backgrounds
  - Smooth animations
  - Skeleton loading
  - Modern card design
- 🌙 **Dark Mode** - Tự động theo cài đặt hệ thống
- ⚡ **Skeleton Loading** - Better UX khi tải dữ liệu
- 📱 **Responsive Design** - Hoạt động mượt trên mọi màn hình

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

## 📦 Dependencies

- `http: ^1.5.0` - Gọi API
- `geolocator: ^14.0.2` - Lấy vị trí GPS
- `provider: ^6.1.5+1` - Quản lý state
- `intl: ^0.20.2` - Format ngày giờ

## 🏗️ Cấu trúc dự án

```
lib/
├── main.dart                 # Entry point + Theme config
├── models/
│   └── weather.dart         # Model dữ liệu thời tiết
├── providers/
│   └── weather_provider.dart # State management
├── screens/
│   └── home_screen.dart     # Màn hình chính (Updated UI)
├── services/
│   └── weather_api.dart     # Service gọi API
└── widgets/
    ├── weather_card.dart    # Widget hiển thị thông tin (Enhanced)
    └── weather_skeleton.dart # Loading skeleton animation
```

## 📱 Cách sử dụng

1. **Chọn quốc gia:**
   - Chọn quốc gia từ dropdown (mặc định: Việt Nam)
   - Danh sách thành phố phổ biến sẽ tự động cập nhật

2. **Tìm kiếm nhanh:**
   - Tap vào chip của thành phố phổ biến
   - Hoặc nhập tên thành phố vào ô tìm kiếm
   - Nhấn nút tìm kiếm hoặc Enter

3. **Sử dụng vị trí hiện tại:**
   - Nhấn nút icon định vị
   - Cho phép ứng dụng truy cập vị trí
   - Thông tin thời tiết sẽ hiển thị dựa trên GPS

4. **Chế độ tối:**
   - App tự động theo cài đặt hệ thống
   - Android: Settings → Display → Dark theme
   - iOS: Settings → Display & Brightness → Dark

## 🔐 Permissions

Ứng dụng yêu cầu các quyền sau:
- `INTERNET` - Để gọi API
- `ACCESS_FINE_LOCATION` - Để lấy vị trí chính xác
- `ACCESS_COARSE_LOCATION` - Để lấy vị trí gần đúng

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

## 🚀 Build APK

Để build APK cho Android:

```bash
# Debug APK (để test)
flutter build apk --debug

# Release APK (để phát hành)
flutter build apk --release

# APK sẽ nằm tại: build/app/outputs/flutter-apk/
```

## � Troubleshooting

### Lỗi API 401 - Unauthorized
- Kiểm tra lại API key trong `lib/main.dart`
- API key mới cần 10-120 phút để kích hoạt
- Tạo API key mới tại https://openweathermap.org/api

### Lỗi GPS không hoạt động
- Bật GPS/Location services trên thiết bị
- Cho phép ứng dụng truy cập vị trí trong Settings
- Trên web browser, GPS có thể không hoạt động chính xác

### App chạy chậm
- Build release APK thay vì debug
- `flutter build apk --release`
- Debug mode luôn chậm hơn release mode

## 📚 Tech Stack

- **Framework**: Flutter 3.9.2+
- **Language**: Dart
- **State Management**: Provider
- **API**: OpenWeatherMap API
- **Architecture**: Clean Architecture (MVVM-like)
- **Design**: Material Design 3

## 🔄 Version History

### v1.1.0 (Current)
- ✨ Thêm Country/Region selector
- ✨ Popular cities quick access
- ✨ Skeleton loading animation
- ✨ Dark mode support
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

## 👥 Nhóm phát triển

Nhóm QuocDat - LTTBDD N04 - 2025

---

**Made with ❤️ using Flutter**

