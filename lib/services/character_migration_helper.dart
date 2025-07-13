import 'package:flutter/foundation.dart';
import '../content_classes/all_content_classes.dart';
import 'character_storage_service.dart';

// Character service wrapper - now uses only the new storage system
// Legacy migration code removed as old system is no longer being read
class CharacterMigrationHelper {
  static CharacterStorageService? _characterService;
  static bool _serviceReady = false;

  static const String notReadyMessage = 'Character service not ready';

  // Initialize the character service
  static Future<void> initialize() async {
    try {
      _characterService = await CharacterStorageService.getInstance();
      _serviceReady = true;
      debugPrint('Character service initialized - using new storage system only');
    } catch (e) {
      debugPrint('Failed to initialize character service: $e');
      _serviceReady = false;
    }
  }

  // Get all characters from the new system
  static Future<List<Character>> getAllCharacters() async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return [];
    }
    
    try {
      return await _characterService!.loadAllCharacters();
    } catch (e) {
      debugPrint('Error loading characters from new system: $e');
      return [];
    }
  }

  // Save a character using the new system only
  static Future<bool> saveCharacter(Character character) async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return false;
    }

    try {
      return await _characterService!.saveCharacter(character);
    } catch (e) {
      debugPrint('Error saving character to new system: $e');
      return false;
    }
  }

  // Delete a character using the new system only
  static Future<bool> deleteCharacter(int uniqueID) async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return false;
    }

    try {
      return await _characterService!.deleteCharacter(uniqueID);
    } catch (e) {
      debugPrint('Error deleting character from new system: $e');
      return false;
    }
  }

  // Find a character by ID using the new system only
  static Future<Character?> findCharacter(int uniqueID) async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return null;
    }
    
    try {
      return await _characterService!.loadCharacter(uniqueID);
    } catch (e) {
      debugPrint('Error loading character from new system: $e');
      return null;
    }
  }

  // Check if character exists in the new system
  static Future<bool> characterExists(int uniqueID) async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return false;
    }
    
    try {
      return await _characterService!.characterExists(uniqueID);
    } catch (e) {
      debugPrint('Error checking character existence: $e');
      return false;
    }
  }

  // Get all character IDs from the new system
  static Future<List<int>> getAllCharacterIds() async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return [];
    }
    
    try {
      return await _characterService!.getCharacterIds();
    } catch (e) {
      debugPrint('Error loading character IDs: $e');
      return [];
    }
  }

  // Check if service is ready
  static bool get serviceIsReady => _serviceReady && _characterService != null;
}
