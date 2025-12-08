import 'package:biblia/core/utils/config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefConfigService implements ConfigService {
  static const String _apiEnabledKey = 'use_api';

  @override
  Future<bool> isApiEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_apiEnabledKey) ?? false;
  }

  @override
  Future<void> setApiEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_apiEnabledKey, value);
  }
}