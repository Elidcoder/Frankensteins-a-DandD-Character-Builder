import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:frankenstein/colour_scheme_class/colour_scheme.dart';
import 'package:frankenstein/content_classes/non_character_classes/background/background.dart';
import 'package:frankenstein/content_classes/non_character_classes/class/class.dart';
import 'package:frankenstein/content_classes/non_character_classes/feat/feat.dart';
import 'package:frankenstein/content_classes/non_character_classes/item/item.dart';
import 'package:frankenstein/content_classes/non_character_classes/proficiency.dart';
import 'package:frankenstein/content_classes/non_character_classes/race/race.dart';
import 'package:frankenstein/content_classes/non_character_classes/spell/spell.dart';
import 'package:frankenstein/services/storage_service.dart' show StorageService;
import 'package:frankenstein/services/storage_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class JsonStorageService implements StorageService {
  static final JsonStorageService _instance = JsonStorageService._internal();
  factory JsonStorageService() => _instance;
  JsonStorageService._internal();

  late Directory _baseDirectory;
  
  bool _initialized = false;
  bool get isInitialized => _initialized;

  static const String _basePath = 'frankenstein_content';

  @override
  Future<bool> initialize() async {
    if (_initialized) return true;
    try {
      final appDocsDir = await getApplicationDocumentsDirectory();
      _baseDirectory = Directory(path.join(appDocsDir.path, _basePath));
      if (!await _baseDirectory.exists()) {
        await _baseDirectory.create(recursive: true);
      }
      _initialized = true;
      debugPrint('JsonStorageService initialized successfully');
      return true;
    } catch (e) {
      debugPrint('JsonStorageService initialization failed: $e');
      return false;
    }
  }

  String _getFullPath(String fileName) {
    return path.join(_baseDirectory.path, fileName);
  }

  Future<Map<String, dynamic>?> _readJson(String fileName) async {
    if (!_initialized) return null;
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
    if (!_initialized) return false;
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
}
