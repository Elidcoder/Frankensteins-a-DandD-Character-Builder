import 'package:flutter/material.dart';
import 'package:frankenstein/services/global_list_manager.dart' show GlobalListManager;

import '../colour_scheme_class/colour_scheme.dart';

/// Service class to manage theme operations
/// Provides a cleaner interface for theme management
class ThemeManager {
  static ThemeManager? _instance;
  static ThemeManager get instance => _instance ??= ThemeManager._internal();
  
  ThemeManager._internal();
  
  ColourScheme _currentScheme = ColourScheme(
    textColour: Colors.white,
    backingColour: Colors.blue,
    backgroundColour: Colors.white,
  );
  
  final List<VoidCallback> _listeners = [];
  
  /// Get the current color scheme
  ColourScheme get currentScheme => _currentScheme;
  
  /// Initialize the theme manager with saved themes
  Future<void> initialize() async {
    await GlobalListManager().initialiseThemeList();
    if (GlobalListManager().themeList.isNotEmpty) {
      _currentScheme = GlobalListManager().themeList.last;
    }
  }
  
  /// Update the current theme and notify listeners
  void updateScheme(ColourScheme newScheme) {    
    // Save only the themes (more efficient than saving all content)
    // TODO(Add error handling for save operation)
    GlobalListManager().saveTheme(newScheme);

    _currentScheme = newScheme;
    
    // Notify all listeners
    for (final listener in _listeners) {
      listener();
    }
  }
  
  /// Add a listener for theme changes
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }
  
  /// Remove a listener for theme changes
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
  
  /// Dispose of all listeners
  void dispose() {
    _listeners.clear();
  }
  
  /// Convert current scheme to ThemeData
  ThemeData get themeData {
    return ThemeData(
      primaryColor: _currentScheme.textColour,
      scaffoldBackgroundColor: _currentScheme.backgroundColour,
      appBarTheme: AppBarTheme(
        backgroundColor: _currentScheme.backingColour,
        foregroundColor: _currentScheme.textColour,
        titleTextStyle: TextStyle(
          color: _currentScheme.textColour,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: _currentScheme.textColour,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: _currentScheme.textColour,
        labelColor: _currentScheme.textColour,
        unselectedLabelColor: _currentScheme.textColour.withOpacity(0.7),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _currentScheme.backingColour,
          foregroundColor: _currentScheme.textColour,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: _currentScheme.backingColour,
          foregroundColor: _currentScheme.textColour,
          side: const BorderSide(width: 3.3, color: Colors.black),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _currentScheme.backingColour,
        foregroundColor: _currentScheme.textColour,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: _currentScheme.textColour),
        bodyMedium: TextStyle(color: _currentScheme.textColour),
        titleLarge: TextStyle(
          color: _currentScheme.textColour,
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: _currentScheme.textColour,
          fontSize: 27,
          fontWeight: FontWeight.w700,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: _currentScheme.backingColour,
        brightness: _getBrightness(),
      ),
    );
  }
  
  /// Determines brightness based on the background color
  Brightness _getBrightness() {
    final luminance = _currentScheme.backgroundColour.computeLuminance();
    return luminance > 0.5 ? Brightness.light : Brightness.dark;
  }
  /// Get the brightness of the current theme
  /// Get saved themes excluding the current theme
  List<ColourScheme> get savedThemes {
    return GlobalListManager().themeList.where((theme) => !_currentScheme.isSameColourScheme(theme)).toList();
  }
}
