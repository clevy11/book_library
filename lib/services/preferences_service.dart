
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> saveSortPreference(String sortOrder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortOrder', sortOrder);
  }

  Future<String?> getSortPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sortOrder');
  }

  Future<void> saveThemePreference(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
  }

  Future<String?> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme');
  }
}
