// External imports
import "package:flutter/material.dart";

// Project imports
import "file_manager/file_manager.dart";
import "services/character_storage_service.dart";
import "theme/theme_manager.dart";
import "theme/theme_manager_widget.dart";
import "widgets/initial_top.dart" show InitialTop, InitialTopKey;

void main() {
  runApp(const FrankensteinApp());
}

class FrankensteinApp extends StatefulWidget {
  const FrankensteinApp({super.key});

  @override
  State<FrankensteinApp> createState() => _FrankensteinAppState();
}

class _FrankensteinAppState extends State<FrankensteinApp> {
  late Future<void> _initializationFuture;
  
  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // Initialize new content storage system
    await initialiseGlobals();
    
    // Initialize new character storage system
    await getCharacterStorageService();
    
    // Initialize character service wrapper
    await CharacterStorageService.initialize();
    
    // Initialize GROUPLIST from current characters (efficient startup)
    await updateGroupListFromNewSystem();
    
    // Initialize theme manager
    ThemeManager.instance.initialize();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ThemeManagerWidget(
            child: InitialTop(key: InitialTopKey),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      "Please wait while the application saves or loads data",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
