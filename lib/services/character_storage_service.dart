import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../content_classes/all_content_classes.dart';

class CharacterStorageService {
  static final CharacterStorageService _instance = CharacterStorageService._internal();
  factory CharacterStorageService() => _instance;
  CharacterStorageService._internal();

  late Directory _baseDirectory;
  bool _initialized = false;

  static const String notReadyMessage = 'Character service not ready';
  static const String _basePath = 'frankenstein_characters';

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      _baseDirectory = Directory(path.join(appDocumentsDir.path, _basePath));
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

  bool get isInitialized => _initialized;

  Future<List<Character>> getAllCharacters() async {
    if (!_initialized) {
      debugPrint(notReadyMessage);
      return [];
    }
    try {
      return await loadAllCharacters();
    } catch (e) {
      debugPrint('Error loading characters from new system: $e');
      return [];
    }
  }

  Future<bool> saveCharacter(Character character) async {
    if (!_initialized) {
      debugPrint(notReadyMessage);
      return false;
    }
    try {
      return await _saveCharacter(character);
    } catch (e) {
      debugPrint('Error saving character to new system: $e');
      return false;
    }
  }

  Future<bool> deleteCharacter(int characterId) async {
    if (!_initialized) {
      debugPrint(notReadyMessage);
      return false;
    }
    try {
      return await _deleteCharacter(characterId);
    } catch (e) {
      debugPrint('Error deleting character: $e');
      return false;
    }
  }

  Future<bool> updateCharacter(Character character) async {
    if (!_initialized) {
      debugPrint(notReadyMessage);
      return false;
    }
    try {
      final characterFile = File(path.join(_baseDirectory.path, '${character.uniqueID}.json'));
      final characterData = character.toJson();
      await characterFile.writeAsString(jsonEncode(characterData));
      await _updateIndex();
      debugPrint('Character ${character.uniqueID} updated successfully');
      return true;
    } catch (e) {
      debugPrint('Error updating character: $e');
      return false;
    }
  }

  Future<bool> _saveCharacter(Character character) async {
    try {
      final characterFile = File(path.join(_baseDirectory.path, '${character.uniqueID}.json'));
      final characterData = character.toJson();
      await characterFile.writeAsString(jsonEncode(characterData));
      await _updateIndex();
      debugPrint('Character ${character.uniqueID} saved successfully');
      return true;
    } catch (e) {
      debugPrint('Error saving character: $e');
      return false;
    }
  }

  Future<bool> _deleteCharacter(int characterId) async {
    try {
      final filePath = path.join(_baseDirectory.path, '$characterId.json');
      debugPrint('Attempting to delete file: $filePath');
      final characterFile = File(filePath);
      if (await characterFile.exists()) {
        debugPrint('File exists, deleting: $filePath');
        await characterFile.delete();
      }
      await _updateIndex();
      debugPrint('Character $characterId deleted successfully');
      return true;
    } catch (e) {
      debugPrint('Error deleting character: $e');
      return false;
    }
  }

  Future<List<Character>> loadAllCharacters() async {
    try {
      final characters = <Character>[];
      final indexFile = File(path.join(_baseDirectory.path, 'index.json'));
      if (await indexFile.exists()) {
        final indexContent = await indexFile.readAsString();
        final indexData = jsonDecode(indexContent) as Map<String, dynamic>;
        final characterIds = List<String>.from(indexData['characters'] ?? []);
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
}
