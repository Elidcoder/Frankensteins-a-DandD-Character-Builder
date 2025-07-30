import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../content_classes/all_content_classes.dart';

// Simple character storage service using direct file operations
class CharacterStorageService {
  static CharacterStorageService? _instance;
  static late final Directory _baseDirectory;
  static bool _initialized = false;

  CharacterStorageService._();

  // Static interface for easy access
  static const String notReadyMessage = 'Character service not ready';
  static const String _basePath = 'frankenstein_characters';

  // Initialize the character service
  static Future<void> initialize() async {
    try {
      _instance = await CharacterStorageService.getInstance();
      debugPrint('Character service initialized - using new storage system only');
    } catch (e) {
      debugPrint('Failed to initialize character service: $e');
    }
  }

  // Static methods that provide error handling and null safety
  
  static Future<List<Character>> getAllCharacters() async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return [];
    }
    
    try {
      return await _instance!.loadAllCharacters();
    } catch (e) {
      debugPrint('Error loading characters from new system: $e');
      return [];
    }
  }

  static Future<bool> saveCharacter(Character character) async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return false;
    }

    try {
      return await _instance!._saveCharacter(character);
    } catch (e) {
      debugPrint('Error saving character to new system: $e');
      return false;
    }
  }

  static Future<bool> deleteCharacter(int characterId) async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return false;
    }

    try {
      return await _instance!._deleteCharacter(characterId);
    } catch (e) {
      debugPrint('Error deleting character: $e');
      return false;
    }
  }

  static bool get serviceIsReady => _instance != null && _initialized;

  // Get the singleton instance and initialize if needed
  static Future<CharacterStorageService> getInstance() async {
    if (_instance == null) {
      _instance = CharacterStorageService._();
      await _instance!._initializeStorage();
    }
    return _instance!;
  }

  Future<void> _initializeStorage() async {
    if (_initialized) return;
    
    try {
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      _baseDirectory = Directory(path.join(appDocumentsDir.path, _basePath));
      
      // Create directory if it doesn't exist
      if (!await _baseDirectory.exists()) {
        await _baseDirectory.create(recursive: true);
        debugPrint('Created character storage directory: ${_baseDirectory.path}');
      } else {
        debugPrint('Using existing character storage directory: ${_baseDirectory.path}');
      }
      
      _initialized = true;
      debugPrint('Character storage service initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize character storage service: $e');
      _initialized = false;
    }
  }

  // Save a character to individual JSON file
  Future<bool> _saveCharacter(Character character) async {
    if (!_initialized) return false;
    
    try {
      // Save character to individual file
      final characterFile = File(path.join(_baseDirectory.path, '${character.uniqueID}.json'));
      final characterData = character.toJson();
      await characterFile.writeAsString(jsonEncode(characterData));
      
      // Update index file
      await _updateIndex();
      
      debugPrint('Character ${character.uniqueID} saved successfully');
      return true;
    } catch (e) {
      debugPrint('Error saving character: $e');
      return false;
    }
  }

  // Delete a character by ID
  Future<bool> _deleteCharacter(int characterId) async {
    if (!_initialized) return false;
    
    try {
      // Delete character file
      final filePath = path.join(_baseDirectory.path, '$characterId.json');
      debugPrint('Attempting to delete file: $filePath');
      final characterFile = File(filePath);

      if (await characterFile.exists()) {
        debugPrint('File exists, deleting: $filePath');
        await characterFile.delete();
      }
      
      // Update index file
      await _updateIndex();
      
      debugPrint('Character $characterId deleted successfully');
      return true;
    } catch (e) {
      debugPrint('Error deleting character: $e');
      return false;
    }
  }

  // Load all characters from storage
  Future<List<Character>> loadAllCharacters() async {
    if (!_initialized) return [];
    
    try {
      final characters = <Character>[];
      
      // First, try to load from index file
      final indexFile = File(path.join(_baseDirectory.path, 'index.json'));
      if (await indexFile.exists()) {
        final indexContent = await indexFile.readAsString();
        final indexData = jsonDecode(indexContent) as Map<String, dynamic>;
        
        // Get character IDs from index
        final characterIds = List<String>.from(indexData['characters'] ?? []);
        
        // Load each character file
        for (final characterId in characterIds) {
          final characterFile = File(path.join(_baseDirectory.path, '$characterId.json'));
          if (await characterFile.exists()) {
            try {
              final characterContent = await characterFile.readAsString();
              final characterData = jsonDecode(characterContent) as Map<String, dynamic>;
              final character = Character.fromJson(characterData);
              characters.add(character);
            } catch (e) {
              debugPrint('Error loading character $characterId: $e');
            }
          }
        }
      } else {
        // Fallback: scan directory for character files
        final files = _baseDirectory.listSync().whereType<File>();
        for (final file in files) {
          if (file.path.endsWith('.json') && !file.path.endsWith('index.json')) {
            try {
              final characterContent = await file.readAsString();
              final characterData = jsonDecode(characterContent) as Map<String, dynamic>;
              final character = Character.fromJson(characterData);
              characters.add(character);
            } catch (e) {
              debugPrint('Error loading character from ${file.path}: $e');
            }
          }
        }
      }
      
      debugPrint('Loaded ${characters.length} characters from storage');
      return characters;
    } catch (e) {
      debugPrint('Error loading characters: $e');
      return [];
    }
  }

  // Update the index file with current character files
  Future<void> _updateIndex() async {
    try {
      final files = _baseDirectory.listSync().whereType<File>();
      final characterIds = files
          .where((file) => file.path.endsWith('.json') && !file.path.endsWith('index.json'))
          .map((file) => path.basenameWithoutExtension(file.path))
          .toList();
      
      final indexData = {
        'characters': characterIds,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      
      final indexFile = File(path.join(_baseDirectory.path, 'index.json'));
      await indexFile.writeAsString(jsonEncode(indexData));
      
      debugPrint('Index updated with ${characterIds.length} characters');
    } catch (e) {
      debugPrint('Error updating index: $e');
    }
  }

  // Check if the service is ready to use
  bool get isInitialized => _initialized;

  static Future<bool> updateCharacter(Character character) async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return false;
    }

    try {
      // Overwrite the character file with new data
      final characterFile = File(path.join(_baseDirectory.path, '${character.uniqueID}.json'));
      final characterData = character.toJson();
      await characterFile.writeAsString(jsonEncode(characterData));

      // Update index file (in case metadata changed)
      await _instance!._updateIndex();

      debugPrint('Character ${character.uniqueID} updated successfully');
      return true;
    } catch (e) {
      debugPrint('Error updating character: $e');
      return false;
    }
  }
}

// Global instance getter for easy access
Future<CharacterStorageService> getCharacterStorageService() async {
  return await CharacterStorageService.getInstance();
}
