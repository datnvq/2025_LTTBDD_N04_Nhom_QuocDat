import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import 'app_strings.dart';

class S {
  static AppStrings of(BuildContext context) {
    // Sử dụng context.read thay vì Provider.of để tránh assertion error
    final localeProvider = context.read<LocaleProvider>();
    return localeProvider.locale.languageCode == 'vi' 
        ? AppStrings.vi 
        : AppStrings.en;
  }
}
