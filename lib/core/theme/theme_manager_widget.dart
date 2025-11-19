import 'package:flutter/material.dart';
import 'theme_manager.dart';

/// Widget that manages theme changes and rebuilds the widget tree
class ThemeManagerWidget extends StatefulWidget {
  final Widget child;

  const ThemeManagerWidget({super.key, required this.child});

  @override
  State<ThemeManagerWidget> createState() => _ThemeManagerWidgetState();
}

class _ThemeManagerWidgetState extends State<ThemeManagerWidget> {
  @override
  void initState() {
    super.initState();
    ThemeManager.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {
      // Rebuild with new theme
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Frankenstein's - a D&D 5e character builder",
      theme: ThemeManager.instance.themeData,
      home: widget.child,
    );
  }
}
