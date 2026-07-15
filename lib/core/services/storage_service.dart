import 'package:hive_flutter/hive_flutter.dart';

/// Persistent storage service using Hive (NoSQL database).
///
/// Manages three types of data:
/// - **Favorites**: Bookmarked tools (stored by route path)
/// - **Settings**: User preferences (theme, language, etc.)
/// - **History**: Tool usage history (capped at 50 items per key)
///
/// Uses singleton pattern to ensure single instance across the app.
class StorageService {
  // Hive box names (each is a separate namespace)
  static const String _favoritesBox = 'favorites';
  static const String _settingsBox = 'settings';
  static const String _historyBox = 'history';

  late Box<String> _favorites;  // Stores favorite tool routes
  late Box<String> _settings;   // Stores key-value settings
  late Box<dynamic> _history;   // Stores tool usage history

  // Singleton pattern: single instance shared across the app
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  /// Initialize Hive and open all required boxes.
  /// Must be called before any storage operations.
  Future<void> init() async {
    await Hive.initFlutter();
    _favorites = await Hive.openBox<String>(_favoritesBox);
    _settings = await Hive.openBox<String>(_settingsBox);
    _history = await Hive.openBox<dynamic>(_historyBox);
  }

  // ─── Favorites Management ───

  /// Get all favorite tool route paths
  List<String> getFavorites() => _favorites.values.toList();

  /// Add a tool to favorites (by its route path)
  Future<void> addFavorite(String toolId) async {
    await _favorites.put(toolId, toolId);
  }

  /// Remove a tool from favorites
  Future<void> removeFavorite(String toolId) async {
    await _favorites.delete(toolId);
  }

  /// Check if a tool is in favorites
  bool isFavorite(String toolId) => _favorites.containsKey(toolId);

  // ─── Settings Management ───

  /// Get a setting value by key (returns null if not found)
  String? getSetting(String key) => _settings.get(key);

  /// Save a setting value
  Future<void> setSetting(String key, String value) async {
    await _settings.put(key, value);
  }

  // ─── History Management ───

  /// Get history items for a specific tool (key = tool name/route)
  List<dynamic> getHistory(String key) {
    return _history.get(key, defaultValue: []) ?? [];
  }

  /// Add an item to the beginning of history (most recent first).
  /// Automatically trims to 50 items max per tool.
  Future<void> addToHistory(String key, dynamic item) async {
    final history = getHistory(key);
    history.insert(0, item); // Insert at beginning (most recent)
    if (history.length > 50) history.removeLast(); // Cap at 50 items
    await _history.put(key, history);
  }

  /// Clear all history for a specific tool
  Future<void> clearHistory(String key) async {
    await _history.delete(key);
  }
}
