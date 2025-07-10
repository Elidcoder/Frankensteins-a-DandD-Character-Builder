import 'package:flutter/foundation.dart';
import '../content_classes/all_content_classes.dart';
import 'storage/storage.dart';

// Simple character storage service using the new storage system
class CharacterStorageService {
  static CharacterStorageService? _instance;
  late final JsonFileStorage _storage;
  bool _initialized = false;

  CharacterStorageService._();

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
    
    final config = StorageConfig(
      basePath: 'frankenstein_characters',
      enableValidation: true,
    );
    _storage = JsonFileStorage(config);
    _initialized = await _storage.initialize();
    if (!_initialized) {
      // TODO: Add proper error handling - provide user notification, fallback strategies
      debugPrint('Failed to initialize character storage service');
    }
  }

  // Save a character to individual JSON file
  Future<bool> saveCharacter(Character character) async {
    if (!_initialized) return false;
    
    try {
      final characterData = character.toJson();
      final fileName = 'character_${character.uniqueID}.json';
      return await _storage.writeJson(fileName, characterData);
    } catch (e) {
      // TODO: Add proper error handling - show user-friendly error messages, retry logic
      debugPrint('Error saving character: $e');
      return false;
    }
  }

  // Load a specific character by ID
  Future<Character?> loadCharacter(int uniqueID) async {
    if (!_initialized) return null;
    
    try {
      final fileName = 'character_$uniqueID.json';
      final characterData = await _storage.readJson(fileName);
      if (characterData == null) return null;
      return Character.fromJson(characterData);
    } catch (e) {
      // TODO: Add proper error handling - distinguish between file not found vs corruption
      debugPrint('Error loading character: $e');
      return null;
    }
  }

  // Delete a character file
  Future<bool> deleteCharacter(int uniqueID) async {
    if (!_initialized) return false;
    
    try {
      final fileName = 'character_$uniqueID.json';
      return await _storage.delete(fileName);
    } catch (e) {
      // TODO: Add proper error handling - confirm deletion, handle permission errors
      debugPrint('Error deleting character: $e');
      return false;
    }
  }

  // Check if the service is ready to use
  bool get isInitialized => _initialized;
}

// Global instance getter for easy access during migration
// Usage: final service = await getCharacterStorageService();
Future<CharacterStorageService> getCharacterStorageService() async {
  return await CharacterStorageService.getInstance();
}
