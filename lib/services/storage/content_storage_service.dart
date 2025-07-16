import 'package:flutter/foundation.dart';
import 'json_file_storage.dart';
import 'file_storage.dart';
import '../../content_classes/non_character_classes/spell/spell.dart';
import '../../content_classes/non_character_classes/class/class.dart';
import '../../content_classes/non_character_classes/race/race.dart';
import '../../content_classes/non_character_classes/feat/feat.dart';
import '../../content_classes/non_character_classes/item/item.dart';
import '../../content_classes/non_character_classes/background/background.dart';
import '../../content_classes/non_character_classes/proficiency.dart';
import '../../colour_scheme_class/colour_scheme.dart';

/// Content Storage Service - Manages separate file storage for each D&D content type
/// Uses JsonFileStorage for atomic operations and data integrity
/// Provides separate files: spells.json, classes.json, races.json, etc.
class ContentStorageService {
  static final Map<String, JsonFileStorage> _storageInstances = {};
  static bool _initialized = false;
  
  // Storage configuration
  static final StorageConfig _config = StorageConfig(
    basePath: 'frankenstein_content', // Separate from legacy path
    enableValidation: true,
  );
  
  /// Initialize all storage instances
  static Future<bool> initialize() async {
    if (_initialized) return true;
    
    try {
      // Initialize all content type storages
      final storages = [
        spellStorage,
        classStorage,
        raceStorage,
        featStorage,
        itemStorage,
        backgroundStorage,
        proficiencyStorage,
        languageStorage,
        themeStorage,
      ];
      
      for (final storage in storages) {
        final success = await storage.initialize();
        if (!success) {
          debugPrint('Failed to initialize storage: ${storage.runtimeType}');
          return false;
        }
      }
      
      _initialized = true;
      debugPrint('ContentStorageService initialized successfully');
      return true;
    } catch (e) {
      debugPrint('ContentStorageService initialization failed: $e');
      return false;
    }
  }
  
  /// Get storage instance for specific content type
  static JsonFileStorage _getStorage(String contentType) {
    return _storageInstances.putIfAbsent(contentType, () {
      return JsonFileStorage(_config);
    });
  }
  
  // ==================== Content-specific storages ====================
  
  /// Storage for spells (spells.json)
  static JsonFileStorage get spellStorage => _getStorage('spells');
  
  /// Storage for classes (classes.json)
  static JsonFileStorage get classStorage => _getStorage('classes');
  
  /// Storage for races (races.json)
  static JsonFileStorage get raceStorage => _getStorage('races');
  
  /// Storage for feats (feats.json)
  static JsonFileStorage get featStorage => _getStorage('feats');
  
  /// Storage for items (items.json)
  static JsonFileStorage get itemStorage => _getStorage('items');
  
  /// Storage for backgrounds (backgrounds.json)
  static JsonFileStorage get backgroundStorage => _getStorage('backgrounds');
  
  /// Storage for proficiencies (proficiencies.json)
  static JsonFileStorage get proficiencyStorage => _getStorage('proficiencies');
  
  /// Storage for languages (languages.json)
  static JsonFileStorage get languageStorage => _getStorage('languages');
  
  /// Storage for themes (themes.json)
  static JsonFileStorage get themeStorage => _getStorage('themes');
  
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
      
      return await spellStorage.writeJson('spells.json', data);
    } catch (e) {
      debugPrint('Failed to save spells: $e');
      return false;
    }
  }
  
  /// Load spells from spells.json
  static Future<List<Spell>> loadSpells() async {
    try {
      final data = await spellStorage.readJson('spells.json');
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
      
      return await classStorage.writeJson('classes.json', data);
    } catch (e) {
      debugPrint('Failed to save classes: $e');
      return false;
    }
  }
  
  /// Load classes from classes.json
  static Future<List<Class>> loadClasses() async {
    try {
      final data = await classStorage.readJson('classes.json');
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
      
      return await raceStorage.writeJson('races.json', data);
    } catch (e) {
      debugPrint('Failed to save races: $e');
      return false;
    }
  }
  
  /// Load races from races.json
  static Future<List<Race>> loadRaces() async {
    try {
      final data = await raceStorage.readJson('races.json');
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
      
      return await featStorage.writeJson('feats.json', data);
    } catch (e) {
      debugPrint('Failed to save feats: $e');
      return false;
    }
  }
  
  /// Load feats from feats.json
  static Future<List<Feat>> loadFeats() async {
    try {
      final data = await featStorage.readJson('feats.json');
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
      
      return await itemStorage.writeJson('items.json', data);
    } catch (e) {
      debugPrint('Failed to save items: $e');
      return false;
    }
  }
  
  /// Load items from items.json
  static Future<List<Item>> loadItems() async {
    try {
      final data = await itemStorage.readJson('items.json');
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
      
      return await backgroundStorage.writeJson('backgrounds.json', data);
    } catch (e) {
      debugPrint('Failed to save backgrounds: $e');
      return false;
    }
  }
  
  /// Load backgrounds from backgrounds.json
  static Future<List<Background>> loadBackgrounds() async {
    try {
      final data = await backgroundStorage.readJson('backgrounds.json');
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
      
      return await proficiencyStorage.writeJson('proficiencies.json', data);
    } catch (e) {
      debugPrint('Failed to save proficiencies: $e');
      return false;
    }
  }
  
  /// Load proficiencies from proficiencies.json
  static Future<List<Proficiency>> loadProficiencies() async {
    try {
      final data = await proficiencyStorage.readJson('proficiencies.json');
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
      
      return await languageStorage.writeJson('languages.json', data);
    } catch (e) {
      debugPrint('Failed to save languages: $e');
      return false;
    }
  }
  
  /// Load languages from languages.json
  static Future<List<String>> loadLanguages() async {
    try {
      final data = await languageStorage.readJson('languages.json');
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
      
      return await themeStorage.writeJson('themes.json', data);
    } catch (e) {
      debugPrint('Failed to save themes: $e');
      return false;
    }
  }
  
  /// Load themes from themes.json
  static Future<List<ColourScheme>> loadThemes() async {
    try {
      final data = await themeStorage.readJson('themes.json');
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
    final storage = _getStorage(contentType);
    return await storage.exists('$contentType.json');
  }
  
  /// Get the size of a specific content file
  static Future<int> getContentSize(String contentType) async {
    final storage = _getStorage(contentType);
    return await storage.getFileSize('$contentType.json');
  }
  
  /// Get the last modification time of a specific content file
  static Future<DateTime?> getContentModificationTime(String contentType) async {
    final storage = _getStorage(contentType);
    return await storage.getModificationTime('$contentType.json');
  }
  
  /// Validate a specific content file
  static Future<bool> validateContent(String contentType) async {
    final storage = _getStorage(contentType);
    return await storage.validateFile('$contentType.json');
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
          final size = await getContentSize(contentType);
          final modTime = await getContentModificationTime(contentType);
          final isValid = await validateContent(contentType);
          
          metadata[contentType] = {
            'exists': exists,
            'size': size,
            'lastModified': modTime?.toIso8601String(),
            'isValid': isValid,
          };
        } else {
          metadata[contentType] = {
            'exists': false,
            'size': 0,
            'lastModified': null,
            'isValid': false,
          };
        }
      } catch (e) {
        debugPrint('Failed to get metadata for $contentType: $e');
        metadata[contentType] = {
          'exists': false,
          'size': 0,
          'lastModified': null,
          'isValid': false,
          'error': e.toString(),
        };
      }
    }
    
    return metadata;
  }
  
  /// Backup a specific content file
  static Future<bool> backupContent(String contentType) async {
    try {
      final storage = _getStorage(contentType);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupFileName = '${contentType}_backup_$timestamp.json';
      
      return await storage.copyFile('$contentType.json', backupFileName);
    } catch (e) {
      debugPrint('Failed to backup $contentType: $e');
      return false;
    }
  }
  
  /// Backup all content files
  static Future<Map<String, bool>> backupAllContent() async {
    final contentTypes = [
      'spells', 'classes', 'races', 'feats', 
      'items', 'backgrounds', 'proficiencies', 'languages', 'themes'
    ];
    
    final results = <String, bool>{};
    
    for (final contentType in contentTypes) {
      results[contentType] = await backupContent(contentType);
    }
    
    return results;
  }
  
  /// Get storage statistics
  static Future<Map<String, dynamic>> getStorageStats() async {
    final metadata = await getContentMetadata();
    int totalSize = 0;
    int validFiles = 0;
    int totalFiles = 0;
    
    for (final entry in metadata.values) {
      if (entry['exists'] == true) {
        totalFiles++;
        totalSize += (entry['size'] as int?) ?? 0;
        if (entry['isValid'] == true) {
          validFiles++;
        }
      }
    }
    
    return {
      'totalFiles': totalFiles,
      'validFiles': validFiles,
      'totalSize': totalSize,
      'averageSize': totalFiles > 0 ? totalSize / totalFiles : 0,
      'healthScore': totalFiles > 0 ? validFiles / totalFiles : 0,
      'lastCheck': DateTime.now().toIso8601String(),
    };
  }
}
