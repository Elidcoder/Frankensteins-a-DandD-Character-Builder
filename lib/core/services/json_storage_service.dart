import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:frankenstein/core/services/storage_service.dart' show StorageService;
import 'package:frankenstein/core/services/storage_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import "../../../models/index.dart";

class JsonStorageService implements StorageService {
  // TODO(LOOK FOR RACE CONDITIONS - MAYBE USE MUTEX)
  static final JsonStorageService _instance = JsonStorageService._internal();
  factory JsonStorageService() => _instance;
  JsonStorageService._internal();

  late Directory _baseDirectory;
  late Directory _characterDirectory;
  
  bool _initialized = false;
  bool get isInitialized => _initialized;

  static const String _contentPath = 'frankenstein_content';
  static const String _charactersSubfolder = 'frankenstein_characters';

  static const String characterNotReadyMessage = 'Character service not ready';
  static const String contentNotReadyMessage   = 'Content service not ready';

  @override
  Future<bool> initialize() async {
    if (_initialized) return true;
    try {
      final appDocsDir = await getApplicationDocumentsDirectory();

      // Initialise content storage
      _baseDirectory = Directory(path.join(appDocsDir.path, _contentPath));
      if (!await _baseDirectory.exists()) {
        await _baseDirectory.create(recursive: true);
        debugPrint('Created main storage directory: ${_baseDirectory.path}');
      } else {
        debugPrint('Using existing main storage directory: ${_baseDirectory.path}');
      }

      // initialise character storage
      _characterDirectory = Directory(path.join(appDocsDir.path, _contentPath, _charactersSubfolder));
      if (!await _characterDirectory.exists()) {
        await _characterDirectory.create(recursive: true);
        debugPrint('Created character storage directory: ${_characterDirectory.path}');
      } else {
        debugPrint('Using existing character storage directory: ${_characterDirectory.path}');
      }

      _initialized = true;
      debugPrint('JsonStorageService initialized successfully');
      return true;
    } catch (e) {
      // TODO(Possibly attempt some kind of file repair or warning system)
      debugPrint('JsonStorageService initialization failed: $e');
      return false;
    }
  }

  String _getFullPath(String fileName) {
    return path.join(_baseDirectory.path, fileName);
  }

  Future<Map<String, dynamic>?> _readJson(String fileName) async {
    if (!_initialized) {
      debugPrint(contentNotReadyMessage);
      return null;
    }
    try {
      final file = File(_getFullPath(fileName));
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      if (content.isEmpty) return null;
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Failed to read JSON from $fileName: $e');
      return null;
    }
  }

  Future<bool> _writeJson(String fileName, Map<String, dynamic> data) async {
    if (!_initialized) {
      debugPrint(contentNotReadyMessage);
      return false;
    }
    try {
      final jsonString = jsonEncode(data);
      final fullPath = _getFullPath(fileName);
      final targetFile = File(fullPath);
      final parentDir = targetFile.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }
      final tempFile = File('$fullPath.tmp');
      try {
        await tempFile.writeAsString(jsonString);
        await tempFile.rename(fullPath);
        return true;
      } catch (e) {
        if (await tempFile.exists()) {
          try {
            await tempFile.delete();
          } catch (_) {}
        }
        rethrow;
      }
    } catch (e) {
      debugPrint('Failed to write JSON to $fileName: $e');
      return false;
    }
  }

  @override
  Future<List<Background>> loadBackgrounds() async {
    try {
      final data = await _readJson('backgrounds.json');
      if (data == null || data['backgrounds'] == null) {
        debugPrint('No background data found');
        return [];
      }
      final backgroundList = data['backgrounds'] as List;
      return backgroundList.map((json) => Background.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to load backgrounds: $e');
      return [];
    }
  }

  @override
  Future<List<Class>> loadClasses() async {
    try {
      final data = await _readJson('classes.json');
      if (data == null || data['classes'] == null) {
        debugPrint('No class data found');
        return [];
      }
      final classList = data['classes'] as List;
      return classList.map((json) => Class.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to load classes: $e');
      return [];
    }
  }

  @override
  Future<List<Feat>> loadFeats() async {
    try {
      final data = await _readJson('feats.json');
      if (data == null || data['feats'] == null) {
        debugPrint('No feat data found');
        return [];
      }
      final featList = data['feats'] as List;
      return featList.map((json) => Feat.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to load feats: $e');
      return [];
    }
  }

  @override
  Future<List<Item>> loadItems() async {
    try {
      final data = await _readJson('items.json');
      if (data == null || data['items'] == null) {
        debugPrint('No item data found');
        return [];
      }
      final itemList = data['items'] as List;
      return itemList.map((json) => Item.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to load items: $e');
      return [];
    }
  }

  @override
  Future<List<String>> loadLanguages() async {
    try {
      final data = await _readJson('languages.json');
      if (data == null || data['languages'] == null) {
        debugPrint('No language data found');
        return [];
      }
      final languageList = data['languages'] as List;
      return languageList.cast<String>();
    } catch (e) {
      debugPrint('Failed to load languages: $e');
      return [];
    }
  }

  @override
  Future<List<Proficiency>> loadProficiencies() async {
    try {
      final data = await _readJson('proficiencies.json');
      if (data == null || data['proficiencies'] == null) {
        debugPrint('No proficiency data found');
        return [];
      }
      final proficiencyList = data['proficiencies'] as List;
      return proficiencyList.map((json) => Proficiency.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to load proficiencies: $e');
      return [];
    }
  }

  @override
  Future<List<Race>> loadRaces() async {
    try {
      final data = await _readJson('races.json');
      if (data == null || data['races'] == null) {
        debugPrint('No race data found');
        return [];
      }
      final raceList = data['races'] as List;
      return raceList.map((json) => Race.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to load races: $e');
      return [];
    }
  }

  @override
  Future<List<Spell>> loadSpells() async {
    try {
      final data = await _readJson('spells.json');
      if (data == null || data['spells'] == null) {
        debugPrint('No spell data found');
        return [];
      }
      final spellList = data['spells'] as List;
      return spellList.map((json) => Spell.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to load spells: $e');
      return [];
    }
  }

  @override
  Future<List<ColourScheme>> loadThemes() async {
    try {
      final data = await _readJson('themes.json');
      if (data == null || data['themes'] == null) {
        debugPrint('No theme data found');
        return [];
      }
      final themeList = data['themes'] as List;
      return themeList.map((json) => ColourScheme.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to load themes: $e');
      return [];
    }
  }

  @override
  Future<bool> saveBackgrounds(List<Background> backgrounds) async {
    try {
      final data = {
        'backgrounds': backgrounds.map((bg) => bg.toJson()).toList(),
        'version': '1.0',
        'contentType': 'backgrounds',
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _writeJson('backgrounds.json', data);
    } catch (e) {
      debugPrint('Failed to save backgrounds: $e');
      return false;
    }
  }

  @override
  Future<bool> saveClasses(List<Class> classes) async {
    try {
      final data = {
        'classes': classes.map((cls) => cls.toJson()).toList(),
        'version': '1.0',
        'contentType': 'classes',
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _writeJson('classes.json', data);
    } catch (e) {
      debugPrint('Failed to save classes: $e');
      return false;
    }
  }

  @override
  Future<bool> saveFeats(List<Feat> feats) async {
    try {
      final data = {
        'feats': feats.map((feat) => feat.toJson()).toList(),
        'version': '1.0',
        'contentType': 'feats',
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _writeJson('feats.json', data);
    } catch (e) {
      debugPrint('Failed to save feats: $e');
      return false;
    }
  }

  @override
  Future<bool> saveItems(List<Item> items) async {
    try {
      final data = {
        'items': items.map((item) => item.toJson()).toList(),
        'version': '1.0',
        'contentType': 'items',
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _writeJson('items.json', data);
    } catch (e) {
      debugPrint('Failed to save items: $e');
      return false;
    }
  }

  @override
  Future<bool> saveLanguages(List<String> languages) async {
    try {
      final data = {
        'languages': languages,
        'version': '1.0',
        'contentType': 'languages',
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _writeJson('languages.json', data);
    } catch (e) {
      debugPrint('Failed to save languages: $e');
      return false;
    }
  }

  @override
  Future<bool> saveProficiencies(List<Proficiency> proficiencies) async {
    try {
      final data = {
        'proficiencies': proficiencies.map((prof) => prof.toJson()).toList(),
        'version': '1.0',
        'contentType': 'proficiencies',
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _writeJson('proficiencies.json', data);
    } catch (e) {
      debugPrint('Failed to save proficiencies: $e');
      return false;
    }
  }

  @override
  Future<bool> saveRaces(List<Race> races) async {
    try {
      final data = {
        'races': races.map((race) => race.toJson()).toList(),
        'version': '1.0',
        'contentType': 'races',
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _writeJson('races.json', data);
    } catch (e) {
      debugPrint('Failed to save races: $e');
      return false;
    }
  }

  @override
  Future<bool> saveSpells(List<Spell> spells) async {
    try {
      final data = {
        'spells': spells.map((spell) => spell.toJson()).toList(),
        'version': '1.0',
        'contentType': 'spells',
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _writeJson('spells.json', data);
    } catch (e) {
      debugPrint('Failed to save spells: $e');
      return false;
    }
  }

  @override
  Future<bool> saveThemes(List<ColourScheme> themes) async {
    try {
      final data = {
        'themes': themes.map((theme) => theme.toJson()).toList(),
        'version': '1.0',
        'contentType': 'themes',
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _writeJson('themes.json', data);
    } catch (e) {
      debugPrint('Failed to save themes: $e');
      return false;
    }
  }



  // Character operations
  // Updates the index file to ensure it is up to date with the current characters
  Future<void> _updateIndex() async {
    try {
      final files = _characterDirectory.listSync().whereType<File>();
      final characterIds = files
          .where((file) => file.path.endsWith('.json') && !file.path.endsWith('index.json'))
          .map((file) => path.basenameWithoutExtension(file.path))
          .toList();
      final indexData = {
        'characters': characterIds,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      final indexFile = File(path.join(_characterDirectory.path, 'index.json'));
      await indexFile.writeAsString(jsonEncode(indexData));
      debugPrint('Index updated with ${characterIds.length} characters');
    } catch (e) {
      debugPrint('Error updating index: $e');
    }
  }

  @override
  Future<bool> deleteCharacter(int characterId) async {
    if (!_initialized) {
      debugPrint(characterNotReadyMessage);
      return false;
    }
    try {
      final filePath = path.join(_characterDirectory.path, '$characterId.json');
      debugPrint('Attempting to delete file: $filePath');
      final characterFile = File(filePath);
      if (await characterFile.exists()) {
        debugPrint('File exists, deleting: $filePath');
        await characterFile.delete();
      }
      await _updateIndex();
      debugPrint('Character (ID: $characterId) deleted successfully');
      return true;
    } catch (e) {
      debugPrint('Error deleting character (ID: $characterId): $e');
      return false;
    }
  }

  @override
  Future<List<Character>> getAllCharacters() async {
    if (!_initialized) {
      debugPrint(characterNotReadyMessage);
      return [];
    }
    try {
      return await _loadAllCharacters();
    } catch (e) {
      debugPrint('Error loading characters from new system: $e');
      return [];
    }
  }

  //TODO(Cleanup function)
  // Function can error, this should be handled by the caller
  Future<List<Character>> _loadAllCharacters() async {
    final characters = <Character>[];
    final indexFile = File(path.join(_characterDirectory.path, 'index.json'));
    if (await indexFile.exists()) {
      final indexContent = await indexFile.readAsString();
      final indexData = jsonDecode(indexContent) as Map<String, dynamic>;
      final characterIds = List<String>.from(indexData['characters'] ?? []);
      for (final characterId in characterIds) {
        final characterFile = File(path.join(_characterDirectory.path, '$characterId.json'));
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
      final files = _characterDirectory.listSync().whereType<File>();
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
}

  @override
  Future<bool> saveCharacter(Character character) async {
    if (!_initialized) {
      debugPrint(characterNotReadyMessage);
      return false;
    }
    try {
      final characterFile = File(path.join(_characterDirectory.path, '${character.uniqueID}.json'));
      final characterData = character.toJson();
      await characterFile.writeAsString(jsonEncode(characterData));
      await _updateIndex();
      debugPrint('Character  ${character.name}, UID: ${character.uniqueID}, saved successfully');
      return true;
    } catch (e) {
      debugPrint('Error saving character ${character.name}, UID: ${character.uniqueID}: $e');
      return false;
    }
  }

  @override
  Future<bool> updateCharacter(Character character) async {
    if (!_initialized) {
      debugPrint(characterNotReadyMessage);
      return false;
    }
    try {
      final characterFile = File(path.join(_characterDirectory.path, '${character.uniqueID}.json'));
      final characterData = character.toJson();
      await characterFile.writeAsString(jsonEncode(characterData));
      await _updateIndex();
      debugPrint('Character  ${character.name}, UID: ${character.uniqueID}, updated successfully');
      return true;
    } catch (e) {
      debugPrint('Error updating character ${character.name}, UID: ${character.uniqueID}: $e');
      return false;
    }
  }
}
