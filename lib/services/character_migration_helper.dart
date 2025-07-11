import 'package:flutter/foundation.dart';
import '../content_classes/all_content_classes.dart';
import '../file_manager/file_manager.dart' show CHARACTERLIST;
import 'character_storage_service.dart';

// Migration helper to gradually move from CHARACTERLIST to CharacterStorageService
// This class provides a bridge between the old and new systems
class CharacterMigrationHelper {
  static CharacterStorageService? _characterService;
  static bool _migrationEnabled = false;

  // Initialize the migration helper
  static Future<void> initialize() async {
    try {
      _characterService = await CharacterStorageService.getInstance();
      _migrationEnabled = true;
      debugPrint('Character migration helper initialized');
    } catch (e) {
      debugPrint('Failed to initialize character migration helper: $e');
      _migrationEnabled = false;
    }
  }

  // Get all characters (tries new system first, falls back to legacy)
  static Future<List<Character>> getAllCharacters() async {
    if (_migrationEnabled && _characterService != null) {
      try {
        final newSystemCharacters = await _characterService!.loadAllCharacters();
        if (newSystemCharacters.isNotEmpty) {
          // If we found characters in the new system, use those
          return newSystemCharacters;
        }
      } catch (e) {
        debugPrint('Error loading from new system, falling back to legacy: $e');
      }
    }
    
    // Fall back to legacy system
    return List<Character>.from(CHARACTERLIST);
  }

  // Save a character (saves to both systems during migration)
  static Future<bool> saveCharacter(Character character) async {
    bool legacySuccess = true;

    // Save to legacy system
    try {
      // Update or add to CHARACTERLIST
      final existingIndex = CHARACTERLIST.indexWhere((c) => c.uniqueID == character.uniqueID);
      if (existingIndex != -1) {
        CHARACTERLIST[existingIndex] = character;
      } else {
        CHARACTERLIST.add(character);
      }
    } catch (e) {
      debugPrint('Error saving to legacy system: $e');
      legacySuccess = false;
    }

    // Save to new system
    if (_migrationEnabled && _characterService != null) {
      try {
        await _characterService!.saveCharacter(character);
      } catch (e) {
        debugPrint('Error saving to new system: $e');
      }
    }

    return legacySuccess; // For now, prioritize legacy system success
  }

  // Delete a character (removes from both systems)
  static Future<bool> deleteCharacter(int uniqueID) async {
    bool legacySuccess = true;

    // Delete from legacy system
    try {
      CHARACTERLIST.removeWhere((c) => c.uniqueID == uniqueID);
    } catch (e) {
      debugPrint('Error deleting from legacy system: $e');
      legacySuccess = false;
    }

    // Delete from new system
    if (_migrationEnabled && _characterService != null) {
      try {
        await _characterService!.deleteCharacter(uniqueID);
      } catch (e) {
        debugPrint('Error deleting from new system: $e');
      }
    }

    return legacySuccess; // For now, prioritize legacy system success
  }

  // Find a character by ID (tries new system first, falls back to legacy)
  static Future<Character?> findCharacter(int uniqueID) async {
    if (_migrationEnabled && _characterService != null) {
      try {
        final character = await _characterService!.loadCharacter(uniqueID);
        if (character != null) {
          return character;
        }
      } catch (e) {
        debugPrint('Error loading from new system, falling back to legacy: $e');
      }
    }
    
    // Fall back to legacy system
    try {
      return CHARACTERLIST.firstWhere((c) => c.uniqueID == uniqueID);
    } catch (e) {
      return null;
    }
  }

  // Sync characters from legacy system to new system (migration utility)
  static Future<bool> migrateToNewSystem() async {
    if (!_migrationEnabled || _characterService == null) {
      debugPrint('Migration not enabled or service not available');
      return false;
    }

    try {
      int migrated = 0;
      int failed = 0;

      for (final character in CHARACTERLIST) {
        final success = await _characterService!.saveCharacter(character);
        if (success) {
          migrated++;
        } else {
          failed++;
        }
      }

      debugPrint('Migration complete: $migrated characters migrated, $failed failed');
      return failed == 0;
    } catch (e) {
      debugPrint('Error during migration: $e');
      return false;
    }
  }

  // Check if migration system is ready
  static bool get isReady => _migrationEnabled && _characterService != null;
}
