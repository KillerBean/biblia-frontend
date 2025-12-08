abstract class ConfigService {
  Future<bool> isApiEnabled();
  Future<void> setApiEnabled(bool value);
}
