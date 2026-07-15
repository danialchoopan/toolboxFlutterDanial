import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _favoritesBox = 'favorites';
  static const String _settingsBox = 'settings';
  static const String _historyBox = 'history';

  late Box<String> _favorites;
  late Box<String> _settings;
  late Box<dynamic> _history;

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<void> init() async {
    await Hive.initFlutter();
    _favorites = await Hive.openBox<String>(_favoritesBox);
    _settings = await Hive.openBox<String>(_settingsBox);
    _history = await Hive.openBox<dynamic>(_historyBox);
  }

  // Favorites
  List<String> getFavorites() => _favorites.values.toList();

  Future<void> addFavorite(String toolId) async {
    await _favorites.put(toolId, toolId);
  }

  Future<void> removeFavorite(String toolId) async {
    await _favorites.delete(toolId);
  }

  bool isFavorite(String toolId) => _favorites.containsKey(toolId);

  // Settings
  String? getSetting(String key) => _settings.get(key);

  Future<void> setSetting(String key, String value) async {
    await _settings.put(key, value);
  }

  // History
  List<dynamic> getHistory(String key) {
    return _history.get(key, defaultValue: []) ?? [];
  }

  Future<void> addToHistory(String key, dynamic item) async {
    final history = getHistory(key);
    history.insert(0, item);
    if (history.length > 50) history.removeLast();
    await _history.put(key, history);
  }

  Future<void> clearHistory(String key) async {
    await _history.delete(key);
  }
}
