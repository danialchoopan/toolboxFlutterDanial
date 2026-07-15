# جعبه ابزار فارسی | Persian Toolbox

An all-in-one utility toolbox application built with Flutter, featuring a fully localized Persian (Farsi) user interface with RTL support.

## Features

### Implemented Tools

| Category | Tool | Description |
|----------|------|-------------|
| Calculator & Conversion | ماشین حساب | Scientific calculator with Persian digits |
| | تبدیل واحد | Unit converter (length, weight, temperature, volume, area, speed, data) |
| | تبدیل ارز | Currency converter with mock rates |
| | کد QR | QR code generator with color customization |
| | رمزعبور | Password generator with strength indicator |
| Text Tools | ویرایشگر متن | Text editor with word/character counter |
| Daily Tools | انتخاب رنگ | Color picker with RGB sliders and presets |
| | کرنومتر | Stopwatch with lap tracking |
| | تایمر | Timer with presets and custom time |
| | ساعت جهانی | World clock for multiple cities |
| | چراغ قوه | Flashlight toggle |
| | قطب‌نما | Compass with custom rendering |
| Health Tools | BMI | BMI calculator with category visualization |
| | محاسبه سن | Age calculator (Persian calendar) |
| | تخفیف | Discount calculator |
| | انعام | Tip calculator with bill splitting |
| Fun Tools | عدد تادفی | Random number generator with history |

### Core Features

- **Persian RTL UI** - Complete right-to-left support
- **Persian Numbers** - Native Persian digit display (۰-۹)
- **Dark/Light Theme** - Toggle with persistent storage
- **Bottom Navigation** - 5-tab navigation bar
- **Side Drawer** - Quick access to tools
- **Search** - Find tools quickly
- **Favorites** - Bookmark frequently used tools
- **Hive Storage** - Persistent settings and favorites

## Tech Stack

- **Flutter** 3.44.6+
- **GetX** - State management, routing, DI
- **Hive** - Local storage
- **Google Fonts** - Vazirmatn font
- **QR Flutter** - QR code generation

## Getting Started

### Prerequisites

- Flutter SDK 3.44.6 or higher
- Dart SDK 3.12.2 or higher

### Installation

```bash
# Clone the repository
git clone https://github.com/your-repo/toolbox_persian.git

# Navigate to project
cd toolbox_persian

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Proxy Configuration (if needed)

If you're behind a proxy:

```bash
export http_proxy=http://127.0.0.1:2080
export https_proxy=http://127.0.0.1:2080
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── constants/               # Colors, dimensions, text styles
│   ├── localization/            # Persian translations, numbers, dates
│   ├── router/                  # GetX route definitions
│   ├── services/                # Hive storage service
│   └── theme/                   # Light/Dark themes
├── modules/
│   ├── home/                    # Home screen + controller
│   ├── settings/                # Settings screen
│   └── tools/                   # All tool screens
└── widgets/
    ├── common/                  # Reusable widgets
    └── navigation/              # Bottom nav, drawer
```

## Adding New Tools

1. Create a new screen in `lib/modules/tools/`
2. Add route in `lib/core/router/app_routes.dart`
3. Register tool in `lib/modules/home/home_controller.dart`
4. Add translations in `lib/core/localization/app_translations.dart`

## License

Private - All rights reserved.
