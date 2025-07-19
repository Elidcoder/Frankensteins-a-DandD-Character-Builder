import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../content_classes/non_character_classes/spell/spell.dart';
import '../../content_classes/non_character_classes/class/class.dart';
import '../../content_classes/non_character_classes/race/race.dart';
import '../../content_classes/non_character_classes/feat/feat.dart';
import '../../content_classes/non_character_classes/item/item.dart';
import '../../content_classes/non_character_classes/background/background.dart';
import '../../content_classes/non_character_classes/proficiency.dart';
import '../../colour_scheme_class/colour_scheme.dart';

/// Content Storage Service - Direct JSON file management for D&D content
/// Provides atomic operations and data integrity for content files
/// Manages separate files: spells.json, classes.json, races.json, etc.
class ContentStorageService {
  static late final Directory _baseDirectory;
  static bool _initialized = false;
  
  // Base path for content files
  static const String _basePath = 'frankenstein_content';
  
  /// Initialize the storage service
  static Future<bool> initialize() async {
    if (_initialized) return true;
    
    try {
      // Setup base directory
      final appDocsDir = await getApplicationDocumentsDirectory();
      _baseDirectory = Directory(path.join(appDocsDir.path, _basePath));
      
      if (!await _baseDirectory.exists()) {
        await _baseDirectory.create(recursive: true);
      }
      
      _initialized = true;
      debugPrint('ContentStorageService initialized successfully');
      return true;
    } catch (e) {
      debugPrint('ContentStorageService initialization failed: $e');
      return false;
    }
  }
  
  // ==================== Core file operations ====================
  
  /// Get full path for a filename
  static String _getFullPath(String fileName) {
    return path.join(_baseDirectory.path, fileName);
  }
  
  /// Check if a file exists
  static Future<bool> _fileExists(String fileName) async {
    if (!_initialized) return false;
    final file = File(_getFullPath(fileName));
    return await file.exists();
  }
  
  /// Read JSON data from file
  static Future<Map<String, dynamic>?> _readJson(String fileName) async {
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
  
  /// Write JSON data to file with atomic operation
  static Future<bool> _writeJson(String fileName, Map<String, dynamic> data) async {
    if (!_initialized) return false;
    
    try {
      // Validate JSON by encoding it first
      final jsonString = jsonEncode(data);
      
      final fullPath = _getFullPath(fileName);
      final targetFile = File(fullPath);
      
      // Create parent directories if needed
      final parentDir = targetFile.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }
      
      // Atomic write: write to temp file, then rename
      final tempFile = File('$fullPath.tmp');
      try {
        await tempFile.writeAsString(jsonString);
        await tempFile.rename(fullPath);
        return true;
      } catch (e) {
        // Clean up temp file if rename fails
        if (await tempFile.exists()) {
          try {
            await tempFile.delete();
          } catch (_) {
            // Ignore cleanup errors
          }
        }
        rethrow;
      }
    } catch (e) {
      debugPrint('Failed to write JSON to $fileName: $e');
      return false;
    }
  }
  
  // ==================== High-level operations ====================
  
  /// Save spells to spells.json
  static Future<bool> saveSpells(List<Spell> spells) async {
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
  
  /// Load spells from spells.json
  static Future<List<Spell>> loadSpells() async {
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
  
  /// Save classes to classes.json
  static Future<bool> saveClasses(List<Class> classes) async {
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
  
  /// Load classes from classes.json
  static Future<List<Class>> loadClasses() async {
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
  
  /// Save races to races.json
  static Future<bool> saveRaces(List<Race> races) async {
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
  
  /// Load races from races.json
  static Future<List<Race>> loadRaces() async {
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
  
  /// Save feats to feats.json
  static Future<bool> saveFeats(List<Feat> feats) async {
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
  
  /// Load feats from feats.json
  static Future<List<Feat>> loadFeats() async {
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
  
  /// Save items to items.json
  static Future<bool> saveItems(List<Item> items) async {
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
  
  /// Load items from items.json
  static Future<List<Item>> loadItems() async {
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
  
  /// Save backgrounds to backgrounds.json
  static Future<bool> saveBackgrounds(List<Background> backgrounds) async {
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
  
  /// Load backgrounds from backgrounds.json
  static Future<List<Background>> loadBackgrounds() async {
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
  
  /// Save proficiencies to proficiencies.json
  static Future<bool> saveProficiencies(List<Proficiency> proficiencies) async {
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
  
  /// Load proficiencies from proficiencies.json
  static Future<List<Proficiency>> loadProficiencies() async {
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
  
  /// Save languages to languages.json
  static Future<bool> saveLanguages(List<String> languages) async {
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
  
  /// Load languages from languages.json
  static Future<List<String>> loadLanguages() async {
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
  
  /// Save themes to themes.json
  static Future<bool> saveThemes(List<ColourScheme> themes) async {
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
  
  /// Load themes from themes.json
  static Future<List<ColourScheme>> loadThemes() async {
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
  
  // ==================== Utility methods ====================
  
  /// Check if a specific content file exists
  static Future<bool> contentExists(String contentType) async {
    final filename = '$contentType.json';
    return await _fileExists(filename);
  }
  
  /// Get metadata for all content files
  static Future<Map<String, Map<String, dynamic>>> getContentMetadata() async {
    final contentTypes = [
      'spells', 'classes', 'races', 'feats', 
      'items', 'backgrounds', 'proficiencies', 'languages', 'themes'
    ];
    
    final metadata = <String, Map<String, dynamic>>{};
    
    for (final contentType in contentTypes) {
      try {
        final exists = await contentExists(contentType);
        if (exists) {
          final data = await _readJson('$contentType.json');
          
          metadata[contentType] = {
            'exists': exists,
            'version': data?['version'] ?? 'unknown',
            'lastModified': data?['lastUpdated'] ?? 'unknown',
            'itemCount': _getItemCount(data ?? {}, contentType),
          };
        } else {
          metadata[contentType] = {
            'exists': false,
            'version': null,
            'lastModified': null,
            'itemCount': 0,
          };
        }
      } catch (e) {
        debugPrint('Failed to get metadata for $contentType: $e');
        metadata[contentType] = {
          'exists': false,
          'version': null,
          'lastModified': null,
          'itemCount': 0,
          'error': e.toString(),
        };
      }
    }
    
    return metadata;
  }
  
  /// Helper to get item count from data
  static int _getItemCount(Map<String, dynamic> data, String contentType) {
    final key = contentType.toLowerCase();
    if (data[key] is List) {
      return (data[key] as List).length;
    }
    return 0;
  }
  
  /// Get storage statistics
  static Future<Map<String, dynamic>> getStorageStats() async {
    final metadata = await getContentMetadata();
    int totalItems = 0;
    int validFiles = 0;
    int totalFiles = 0;
    
    for (final entry in metadata.values) {
      if (entry['exists'] == true) {
        totalFiles++;
        totalItems += (entry['itemCount'] as int?) ?? 0;
        if (entry['error'] == null) {
          validFiles++;
        }
      }
    }
    
    return {
      'totalFiles': totalFiles,
      'validFiles': validFiles,
      'totalItems': totalItems,
      'averageItemsPerFile': totalFiles > 0 ? totalItems / totalFiles : 0,
      'healthScore': totalFiles > 0 ? validFiles / totalFiles : 0,
      'lastCheck': DateTime.now().toIso8601String(),
    };
  }
}
