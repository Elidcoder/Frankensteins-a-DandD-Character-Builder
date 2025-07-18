import 'package:flutter/foundation.dart';
import '../content_classes/all_content_classes.dart';
import 'storage/file_storage.dart' show StorageConfig;
import 'storage/json_file_storage.dart' show JsonFileStorage;

// Simple character storage service using the new storage system
class CharacterStorageService {
  static CharacterStorageService? _instance;
  late final JsonFileStorage _storage;
  bool _initialized = false;

  CharacterStorageService._();

  // Static interface for easy access (replaces CharacterMigrationHelper)
  static const String notReadyMessage = 'Character service not ready';

  // Initialize the character service (replaces CharacterMigrationHelper.initialize)
  static Future<void> initialize() async {
    try {
      _instance = await CharacterStorageService.getInstance();
      debugPrint('Character service initialized - using new storage system only');
    } catch (e) {
      debugPrint('Failed to initialize character service: $e');
    }
  }

  // Static methods that provide error handling and null safety (replaces CharacterMigrationHelper methods)
  
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

  static Future<bool> deleteCharacter(int uniqueID) async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return false;
    }

    try {
      return await _instance!._deleteCharacter(uniqueID);
    } catch (e) {
      debugPrint('Error deleting character from new system: $e');
      return false;
    }
  }

  static Future<Character?> findCharacter(int uniqueID) async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return null;
    }
    
    try {
      return await _instance!._loadCharacter(uniqueID);
    } catch (e) {
      debugPrint('Error loading character from new system: $e');
      return null;
    }
  }

  static Future<bool> characterExists(int uniqueID) async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return false;
    }
    
    try {
      return await _instance!._characterExists(uniqueID);
    } catch (e) {
      debugPrint('Error checking character existence: $e');
      return false;
    }
  }

  static Future<List<int>> getAllCharacterIds() async {
    if (!serviceIsReady) {
      debugPrint(notReadyMessage);
      return [];
    }
    
    try {
      return await _instance!.getCharacterIds();
    } catch (e) {
      debugPrint('Error loading character IDs: $e');
      return [];
    }
  }

  static bool get serviceIsReady => _instance != null && _instance!._initialized;

  // Instance methods (original functionality)

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
  Future<bool> _saveCharacter(Character character) async {
    if (!_initialized) return false;
    
    try {
      final characterData = character.toJson();
      final fileName = 'character_${character.uniqueID}.json';
      final success = await _storage.writeJson(fileName, characterData);
      
      if (success) {
        // Add to index - if this fails, we have an orphaned file
        final indexUpdated = await _addToIndex(character.uniqueID);
        if (!indexUpdated) {
          // Index update failed - remove the file to maintain consistency
          debugPrint('Index update failed, removing orphaned file for character ${character.uniqueID}');
          await _storage.delete(fileName);
          return false;
        }
      }
      
      return success;
    } catch (e) {
      // TODO: Add proper error handling - show user-friendly error messages, retry logic
      debugPrint('Error saving character: $e');
      return false;
    }
  }

  // Load a specific character by ID
  Future<Character?> _loadCharacter(int uniqueID) async {
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
  Future<bool> _deleteCharacter(int uniqueID) async {
    if (!_initialized) return false;
    
    try {
      // Remove from index first - MUST succeed to prevent corruption
      final indexRemoved = await _removeFromIndex(uniqueID);
      if (!indexRemoved) {
        debugPrint('Error: Failed to remove character $uniqueID from index - aborting deletion to prevent corruption');
        return false; // Exit immediately if index removal fails
      }
      
      // Only proceed with file deletion if index was successfully updated
      final fileName = 'character_$uniqueID.json';
      final fileDeleted = await _storage.delete(fileName);
      
      if (!fileDeleted) {
        // File deletion failed but index was updated - restore index entry
        debugPrint('File deletion failed, restoring index entry for character $uniqueID');
        final rollbackSuccess = await _addToIndex(uniqueID);
        if (!rollbackSuccess) {
          debugPrint('CRITICAL: Failed to rollback index for character $uniqueID - manual intervention may be required');
          // TODO: Add proper error handling - log to error reporting system, notify admin
        }
        return false;
      }
      
      return true; // Both operations succeeded
    } catch (e) {
      // TODO: Add proper error handling - confirm deletion, handle permission errors
      debugPrint('Error deleting character: $e');
      return false;
    }
  }

  // Load all characters from storage
  Future<List<Character>> loadAllCharacters() async {
    if (!_initialized) return [];
    
    try {
      final characters = <Character>[];
      
      // Get all character files (pattern: character_*.json)
      final characterIds = await getCharacterIds();
      
      for (final id in characterIds) {
        final character = await _loadCharacter(id);
        if (character != null) {
          characters.add(character);
        }
      }
      
      return characters;
    } catch (e) {
      // TODO: Add proper error handling - provide partial results, show which files failed
      debugPrint('Error loading all characters: $e');
      return [];
    }
  }

  // Get list of all character IDs that have saved files
  Future<List<int>> getCharacterIds() async {
    if (!_initialized) return [];
    
    try {
      // Load the character index file
      final indexData = await _storage.readJson('character_index.json');
      if (indexData == null || indexData['characterIds'] == null) {
        // No index file exists yet, return empty list
        return [];
      }
      
      // Convert and validate the stored IDs
      final List<dynamic> storedIds = indexData['characterIds'];
      final List<int> validIds = [];
      
      // TODO(Further validate ids based on length)
      for (final id in storedIds) {
        if (id is int) {
          validIds.add(id);
        } else if (id is String) {
          // Try to parse string as int
          final parsedId = int.tryParse(id);
          if (parsedId != null) {
            validIds.add(parsedId);
          } else {
            debugPrint('Warning: Invalid character ID in index: $id');
          }
        } else {
          debugPrint('Warning: Invalid character ID type in index: ${id.runtimeType}');
        }
      }
      
      return validIds;
    } catch (e) {
      // TODO: Add proper error handling - log discovery errors, attempt recovery
      debugPrint('Error loading character index: $e');
      return [];
    }
  }

  // Update the character index when characters are added/removed
  Future<bool> _updateCharacterIndex(List<int> characterIds) async {
    try {
      final indexData = {
        'characterIds': characterIds,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('character_index.json', indexData);
    } catch (e) {
      debugPrint('Error updating character index: $e');
      return false;
    }
  }

  // Add a character ID to the index
  Future<bool> _addToIndex(int characterId) async {
    final currentIds = await getCharacterIds();
    if (!currentIds.contains(characterId)) {
      currentIds.add(characterId);
      return await _updateCharacterIndex(currentIds);
    }
    return true; // Already exists
  }

  // Remove a character ID from the index
  Future<bool> _removeFromIndex(int characterId) async {
    final currentIds = await getCharacterIds();
    final wasPresent = currentIds.remove(characterId);
    
    if (wasPresent) {
      // ID was present and removed, update the index
      return await _updateCharacterIndex(currentIds);
    } else {
      // ID wasn't in the index - this could indicate a problem
      debugPrint('Warning: Attempted to remove character $characterId from index, but it was not present');
      return true; 
    }
  }

  // Utility method to check if a character exists (checks both index and file)
  Future<bool> _characterExists(int uniqueID) async {
    if (!_initialized) return false;
    
    // Check index first (more efficient)
    final characterIds = await getCharacterIds();
    final inIndex = characterIds.contains(uniqueID);
    
    // Also check if file exists
    final fileName = 'character_$uniqueID.json';
    final fileExists = await _storage.exists(fileName);
    
    // Continuing the check allows us to attempt a repair in such an inconsistency
    if (inIndex != fileExists) {
      debugPrint('Inconsistency detected for character $uniqueID: inIndex=$inIndex, fileExists=$fileExists');
      // TODO: Add proper error handling - implement consistency repair mechanism
    }
    
    // Return true only if both index and file agree
    return inIndex && fileExists;
  }

  // Check if the service is ready to use
  bool get isInitialized => _initialized;
}

// Global instance getter for easy access during migration
// Usage: final service = await getCharacterStorageService();
Future<CharacterStorageService> getCharacterStorageService() async {
  return await CharacterStorageService.getInstance();
}
