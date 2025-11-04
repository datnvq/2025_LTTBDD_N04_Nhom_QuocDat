# Weather Now - Ứng dụng xem thời tiết thực

Ứng dụng Android Flutter để xem thông tin thời tiết thực tế sử dụng OpenWeatherMap API.

## ✨ Tính năng

- 🌍 **Tìm kiếm thời tiết theo tên thành phố**
- 📍 **Lấy thời tiết vị trí hiện tại** (sử dụng GPS)
- 🌡️ **Hiển thị thông tin chi tiết:**
  - Nhiệt độ (°C)
  - Mô tả thời tiết
  - Độ ẩm
  - Tốc độ gió
  - Icon thời tiết
- 🎨 **Giao diện đẹp với Material Design 3**

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
├── main.dart                 # Entry point
├── models/
│   └── weather.dart         # Model dữ liệu thời tiết
├── providers/
│   └── weather_provider.dart # State management
├── screens/
│   └── home_screen.dart     # Màn hình chính
├── services/
│   └── weather_api.dart     # Service gọi API
└── widgets/
    └── weather_card.dart    # Widget hiển thị thông tin
```

## 📱 Cách sử dụng

1. **Tìm kiếm theo thành phố:**
   - Nhập tên thành phố vào ô tìm kiếm
   - Nhấn nút tìm kiếm hoặc Enter

2. **Sử dụng vị trí hiện tại:**
   - Nhấn nút icon định vị
   - Cho phép ứng dụng truy cập vị trí
   - Thông tin thời tiết sẽ hiển thị dựa trên GPS

## 🔐 Permissions

Ứng dụng yêu cầu các quyền sau:
- `INTERNET` - Để gọi API
- `ACCESS_FINE_LOCATION` - Để lấy vị trí chính xác
- `ACCESS_COARSE_LOCATION` - Để lấy vị trí gần đúng

## 📝 License

This project is open source and available under the MIT License.

## 👥 Nhóm phát triển

Nhóm QuocDat - LTTBDD N04 - 2025

