import 'package:flutter/foundation.dart';
import '../content_classes/all_content_classes.dart';
import '../colour_scheme_class/colour_scheme.dart';
import 'storage/file_storage.dart' show StorageConfig;
import 'storage/json_file_storage.dart' show JsonFileStorage;

// Content storage service for all non-character game data
// Handles: Races, Classes, Spells, Feats, Items, Backgrounds, Proficiencies, etc.
// Strategy: One file per content type for easier management
//
// PERFORMANCE OPTIMIZATIONS:
// - All bulk operations (loadAllContent, saveAllContent, etc.) run in parallel using Future.wait()
// - File existence checks, metadata gathering, and validations are parallelized
// - Backup/restore operations are optimized for concurrent execution
// - This provides dramatic performance improvements over sequential operations
class ContentStorageService {
  static ContentStorageService? _instance;
  late final JsonFileStorage _storage;
  bool _initialized = false;

  ContentStorageService._();

  static Future<ContentStorageService> getInstance() async {
    if (_instance == null) {
      _instance = ContentStorageService._();
      await _instance!._initializeStorage();
    }
    return _instance!;
  }

  Future<void> _initializeStorage() async {
    if (_initialized) return;
    
    final config = StorageConfig(
      basePath: 'frankenstein_content',
      enableValidation: true,
    );
    _storage = JsonFileStorage(config);
    _initialized = await _storage.initialize();
    if (!_initialized) {
      // TODO: Add proper error handling - provide user notification, fallback strategies
      debugPrint('Failed to initialize content storage service');
    }
  }

  // === SPELL OPERATIONS ===
  Future<bool> saveSpells(List<Spell> spells) async {
    if (!_initialized) return false;
    
    // Validate input
    if (spells.isEmpty) {
      debugPrint('Warning: Attempting to save empty spell list');
    }
    
    try {
      // Validate each spell can be serialized
      final validSpells = <Map<String, dynamic>>[];
      for (int i = 0; i < spells.length; i++) {
        try {
          final spellJson = spells[i].toJson();
          validSpells.add(spellJson);
        } catch (e) {
          debugPrint('Warning: Failed to serialize spell at index $i: $e');
          // TODO: Add proper error handling - decide whether to fail completely or skip invalid items
        }
      }
      
      if (validSpells.length != spells.length) {
        debugPrint('Warning: Only ${validSpells.length}/${spells.length} spells could be serialized');
      }
      
      final spellData = {
        'spells': validSpells,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('spells.json', spellData);
    } catch (e) {
      debugPrint('Error saving spells: $e');
      return false;
    }
  }

  Future<List<Spell>> loadSpells() async {
    if (!_initialized) return [];
    
    try {
      final data = await _storage.readJson('spells.json');
      if (data == null || data['spells'] == null) return [];
      
      return List<Spell>.from(
        (data['spells'] as List).map((x) => Spell.fromJson(x))
      );
    } catch (e) {
      debugPrint('Error loading spells: $e');
      return [];
    }
  }

  // === FEAT OPERATIONS ===
  Future<bool> saveFeats(List<Feat> feats) async {
    if (!_initialized) return false;
    
    try {
      final featData = {
        'feats': feats.map((feat) => feat.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('feats.json', featData);
    } catch (e) {
      debugPrint('Error saving feats: $e');
      return false;
    }
  }

  Future<List<Feat>> loadFeats() async {
    if (!_initialized) return [];
    
    try {
      final data = await _storage.readJson('feats.json');
      if (data == null || data['feats'] == null) return [];
      
      return List<Feat>.from(
        (data['feats'] as List).map((x) => Feat.fromJson(x))
      );
    } catch (e) {
      debugPrint('Error loading feats: $e');
      return [];
    }
  }

  // === RACE OPERATIONS ===
  Future<bool> saveRaces(List<Race> races) async {
    if (!_initialized) return false;
    
    try {
      final raceData = {
        'races': races.map((race) => race.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('races.json', raceData);
    } catch (e) {
      debugPrint('Error saving races: $e');
      return false;
    }
  }

  Future<List<Race>> loadRaces() async {
    if (!_initialized) return [];
    
    try {
      final data = await _storage.readJson('races.json');
      if (data == null || data['races'] == null) return [];
      
      return List<Race>.from(
        (data['races'] as List).map((x) => Race.fromJson(x))
      );
    } catch (e) {
      debugPrint('Error loading races: $e');
      return [];
    }
  }

  // === CLASS OPERATIONS ===
  Future<bool> saveClasses(List<Class> classes) async {
    if (!_initialized) return false;
    
    try {
      final classData = {
        'classes': classes.map((cls) => cls.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('classes.json', classData);
    } catch (e) {
      debugPrint('Error saving classes: $e');
      return false;
    }
  }

  Future<List<Class>> loadClasses() async {
    if (!_initialized) return [];
    
    try {
      final data = await _storage.readJson('classes.json');
      if (data == null || data['classes'] == null) return [];
      
      return List<Class>.from(
        (data['classes'] as List).map((x) => Class.fromJson(x))
      );
    } catch (e) {
      debugPrint('Error loading classes: $e');
      return [];
    }
  }

  // === BACKGROUND OPERATIONS ===
  Future<bool> saveBackgrounds(List<Background> backgrounds) async {
    if (!_initialized) return false;
    
    try {
      final backgroundData = {
        'backgrounds': backgrounds.map((bg) => bg.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('backgrounds.json', backgroundData);
    } catch (e) {
      debugPrint('Error saving backgrounds: $e');
      return false;
    }
  }

  Future<List<Background>> loadBackgrounds() async {
    if (!_initialized) return [];
    
    try {
      final data = await _storage.readJson('backgrounds.json');
      if (data == null || data['backgrounds'] == null) return [];
      
      return List<Background>.from(
        (data['backgrounds'] as List).map((x) => Background.fromJson(x))
      );
    } catch (e) {
      debugPrint('Error loading backgrounds: $e');
      return [];
    }
  }

  // === ITEM OPERATIONS ===
  Future<bool> saveItems(List<Item> items) async {
    if (!_initialized) return false;
    
    try {
      final itemData = {
        'items': items.map((item) => item.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('items.json', itemData);
    } catch (e) {
      debugPrint('Error saving items: $e');
      return false;
    }
  }

  Future<List<Item>> loadItems() async {
    if (!_initialized) return [];
    
    try {
      final data = await _storage.readJson('items.json');
      if (data == null || data['items'] == null) return [];
      
      return List<Item>.from(
        (data['items'] as List).map((x) => Item.fromJson(x))
      );
    } catch (e) {
      debugPrint('Error loading items: $e');
      return [];
    }
  }

  // === PROFICIENCY OPERATIONS ===
  Future<bool> saveProficiencies(List<Proficiency> proficiencies) async {
    if (!_initialized) return false;
    
    try {
      final proficiencyData = {
        'proficiencies': proficiencies.map((prof) => prof.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('proficiencies.json', proficiencyData);
    } catch (e) {
      debugPrint('Error saving proficiencies: $e');
      return false;
    }
  }

  Future<List<Proficiency>> loadProficiencies() async {
    if (!_initialized) return [];
    
    try {
      final data = await _storage.readJson('proficiencies.json');
      if (data == null || data['proficiencies'] == null) return [];
      
      return List<Proficiency>.from(
        (data['proficiencies'] as List).map((x) => Proficiency.fromJson(x))
      );
    } catch (e) {
      debugPrint('Error loading proficiencies: $e');
      return [];
    }
  }

  // === USER CONTENT (Groups, Languages, Themes) ===
  Future<bool> saveGroups(List<String> groups) async {
    if (!_initialized) return false;
    
    try {
      final groupData = {
        'groups': groups,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('groups.json', groupData);
    } catch (e) {
      debugPrint('Error saving groups: $e');
      return false;
    }
  }

  Future<List<String>> loadGroups() async {
    if (!_initialized) return [];
    
    try {
      final data = await _storage.readJson('groups.json');
      if (data == null || data['groups'] == null) return [];
      
      return List<String>.from(data['groups']);
    } catch (e) {
      debugPrint('Error loading groups: $e');
      return [];
    }
  }

  Future<bool> saveLanguages(List<String> languages) async {
    if (!_initialized) return false;
    
    try {
      final languageData = {
        'languages': languages,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('languages.json', languageData);
    } catch (e) {
      debugPrint('Error saving languages: $e');
      return false;
    }
  }

  Future<List<String>> loadLanguages() async {
    if (!_initialized) return [];
    
    try {
      final data = await _storage.readJson('languages.json');
      if (data == null || data['languages'] == null) return [];
      
      return List<String>.from(data['languages']);
    } catch (e) {
      debugPrint('Error loading languages: $e');
      return [];
    }
  }

  Future<bool> saveThemes(List<ColourScheme> themes) async {
    if (!_initialized) return false;
    
    try {
      final themeData = {
        'themes': themes.map((theme) => theme.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      return await _storage.writeJson('themes.json', themeData);
    } catch (e) {
      debugPrint('Error saving themes: $e');
      return false;
    }
  }

  Future<List<ColourScheme>> loadThemes() async {
    if (!_initialized) return [];
    
    try {
      final data = await _storage.readJson('themes.json');
      if (data == null || data['themes'] == null) return [];
      
      return List<ColourScheme>.from(
        (data['themes'] as List).map((x) => ColourScheme.fromJson(x))
      );
    } catch (e) {
      debugPrint('Error loading themes: $e');
      return [];
    }
  }

  // === UTILITY METHODS ===
  bool get isInitialized => _initialized;

  // Save all content types at once (for migration from legacy system) - runs in parallel for efficiency
  Future<bool> saveAllContent({
    List<Spell>? spells,
    List<Feat>? feats,
    List<Race>? races,
    List<Class>? classes,
    List<Background>? backgrounds,
    List<Item>? items,
    List<Proficiency>? proficiencies,
    List<String>? groups,
    List<String>? languages,
    List<ColourScheme>? themes,
  }) async {
    if (!_initialized) return false;

    // Build list of operations to run in parallel
    final operations = <Future<bool>>[];
    final operationNames = <String>[];

    // Add operations only for non-null content
    if (spells != null) {
      operations.add(saveSpells(spells));
      operationNames.add('spells');
    }
    if (feats != null) {
      operations.add(saveFeats(feats));
      operationNames.add('feats');
    }
    if (races != null) {
      operations.add(saveRaces(races));
      operationNames.add('races');
    }
    if (classes != null) {
      operations.add(saveClasses(classes));
      operationNames.add('classes');
    }
    if (backgrounds != null) {
      operations.add(saveBackgrounds(backgrounds));
      operationNames.add('backgrounds');
    }
    if (items != null) {
      operations.add(saveItems(items));
      operationNames.add('items');
    }
    if (proficiencies != null) {
      operations.add(saveProficiencies(proficiencies));
      operationNames.add('proficiencies');
    }
    if (groups != null) {
      operations.add(saveGroups(groups));
      operationNames.add('groups');
    }
    if (languages != null) {
      operations.add(saveLanguages(languages));
      operationNames.add('languages');
    }
    if (themes != null) {
      operations.add(saveThemes(themes));
      operationNames.add('themes');
    }

    if (operations.isEmpty) {
      debugPrint('No content provided to save');
      return true; // Nothing to save is technically successful
    }

    try {
      // Execute all operations in parallel
      final results = await Future.wait(operations);
      
      // Check results and track failures
      final failures = <String>[];
      final successes = <String>[];
      
      for (int i = 0; i < results.length; i++) {
        if (results[i]) {
          successes.add(operationNames[i]);
        } else {
          failures.add(operationNames[i]);
        }
      }

      if (failures.isNotEmpty) {
        debugPrint('Content save completed with ${failures.length} failures: ${failures.join(", ")}');
        debugPrint('Successfully saved: ${successes.join(", ")}');
        return false;
      }

      debugPrint('All content saved successfully: ${successes.join(", ")}');
      return true;
      
    } catch (e) {
      debugPrint('Error during parallel content save: $e');
      return false;
    }
  }

  // Load all content types at once (for initialization) - runs in parallel for efficiency
  Future<Map<String, dynamic>> loadAllContent() async {
    if (!_initialized) return {};

    final loaders = <String, Future Function()>{
      'spells': loadSpells,
      'feats': loadFeats,
      'races': loadRaces,
      'classes': loadClasses,
      'backgrounds': loadBackgrounds,
      'items': loadItems,
      'proficiencies': loadProficiencies,
      'groups': loadGroups,
      'languages': loadLanguages,
      'themes': loadThemes,
    };

    final results = await Future.wait(loaders.values.map((fn) => fn()));

    return Map.fromIterables(loaders.keys, results);
  }

  // Check if all content files exist - runs in parallel for efficiency
  Future<Map<String, bool>> checkContentFilesExist() async {
    if (!_initialized) return {};
    
    final files = [
      'spells.json',
      'feats.json', 
      'races.json',
      'classes.json',
      'backgrounds.json',
      'items.json',
      'proficiencies.json',
      'groups.json',
      'languages.json',
      'themes.json'
    ];
    
    // Run all existence checks in parallel
    final results = await Future.wait(
      files.map((file) => _storage.exists(file))
    );
    
    final resultMap = <String, bool>{};
    for (int i = 0; i < files.length; i++) {
      resultMap[files[i]] = results[i];
    }
    
    return resultMap;
  }

  // === ADDITIONAL UTILITY METHODS ===

  // Delete specific content type file
  Future<bool> deleteContentFile(String contentType) async {
    if (!_initialized) return false;
    
    final fileName = '$contentType.json';
    try {
      return await _storage.delete(fileName);
    } catch (e) {
      debugPrint('Error deleting $fileName: $e');
      return false;
    }
  }

  // Clear all content files (use with caution) - runs in parallel for efficiency
  Future<Map<String, bool>> clearAllContent() async {
    if (!_initialized) return {};
    
    final files = [
      'spells.json',
      'feats.json',
      'races.json',
      'classes.json',
      'backgrounds.json',
      'items.json',
      'proficiencies.json',
      'groups.json',
      'languages.json',
      'themes.json'
    ];
    
    try {
      // Run all deletion operations in parallel
      final results = await Future.wait(
        files.map((file) => _storage.delete(file).catchError((e) {
          debugPrint('Error deleting $file: $e');
          return false;
        }))
      );
      
      final resultMap = <String, bool>{};
      for (int i = 0; i < files.length; i++) {
        resultMap[files[i]] = results[i];
      }
      
      return resultMap;
    } catch (e) {
      debugPrint('Error during parallel content deletion: $e');
      // Return failure map if something goes wrong
      return Map.fromEntries(files.map((file) => MapEntry(file, false)));
    }
  }

  // Create backup of all content files - runs in parallel for efficiency
  Future<bool> createBackup(String backupSuffix) async {
    if (!_initialized) return false;
    
    final files = [
      'spells.json',
      'feats.json',
      'races.json',
      'classes.json',
      'backgrounds.json',
      'items.json',
      'proficiencies.json',
      'groups.json',
      'languages.json',
      'themes.json'
    ];
    
    try {
      // First, check which files exist in parallel
      final existsResults = await Future.wait(
        files.map((file) => _storage.exists(file))
      );
      
      // Filter to only existing files
      final existingFiles = <String>[];
      for (int i = 0; i < files.length; i++) {
        if (existsResults[i]) {
          existingFiles.add(files[i]);
        }
      }
      
      if (existingFiles.isEmpty) {
        debugPrint('No content files found to backup');
        return true; // No files to backup is technically successful
      }
      
      // Load all existing files in parallel
      final dataResults = await Future.wait(
        existingFiles.map((file) => _storage.readJson(file))
      );
      
      // Create backup operations for files that loaded successfully
      final backupOperations = <Future<bool>>[];
      final backupFiles = <String>[];
      
      for (int i = 0; i < existingFiles.length; i++) {
        final data = dataResults[i];
        if (data != null) {
          final file = existingFiles[i];
          final backupFile = file.replaceAll('.json', '_$backupSuffix.json');
          backupOperations.add(_storage.writeJson(backupFile, data));
          backupFiles.add(backupFile);
        }
      }
      
      if (backupOperations.isEmpty) {
        debugPrint('No valid content files found to backup');
        return false;
      }
      
      // Execute all backup writes in parallel
      final backupResults = await Future.wait(backupOperations);
      
      // Check results
      bool allSuccessful = true;
      for (int i = 0; i < backupResults.length; i++) {
        if (!backupResults[i]) {
          debugPrint('Failed to create backup: ${backupFiles[i]}');
          allSuccessful = false;
        }
      }
      
      if (allSuccessful) {
        debugPrint('Successfully created backup for ${backupFiles.length} files with suffix: $backupSuffix');
      }
      
      return allSuccessful;
      
    } catch (e) {
      debugPrint('Error during backup creation: $e');
      return false;
    }
  }

  // Restore content from backup - runs in parallel for efficiency
  Future<bool> restoreFromBackup(String backupSuffix) async {
    if (!_initialized) return false;
    
    final files = [
      'spells.json',
      'feats.json',
      'races.json',
      'classes.json',
      'backgrounds.json',
      'items.json',
      'proficiencies.json',
      'groups.json',
      'languages.json',
      'themes.json'
    ];
    
    try {
      // Create backup file names
      final backupFiles = files.map((file) => 
        file.replaceAll('.json', '_$backupSuffix.json')
      ).toList();
      
      // Check which backup files exist in parallel
      final existsResults = await Future.wait(
        backupFiles.map((file) => _storage.exists(file))
      );
      
      // Filter to only existing backup files
      final existingBackups = <String>[];
      final correspondingFiles = <String>[];
      for (int i = 0; i < backupFiles.length; i++) {
        if (existsResults[i]) {
          existingBackups.add(backupFiles[i]);
          correspondingFiles.add(files[i]);
        }
      }
      
      if (existingBackups.isEmpty) {
        debugPrint('No backup files found with suffix: $backupSuffix');
        return false;
      }
      
      // Load all backup files in parallel
      final dataResults = await Future.wait(
        existingBackups.map((file) => _storage.readJson(file))
      );
      
      // Create restore operations for files that loaded successfully
      final restoreOperations = <Future<bool>>[];
      final restoreFiles = <String>[];
      
      for (int i = 0; i < existingBackups.length; i++) {
        final data = dataResults[i];
        if (data != null) {
          final targetFile = correspondingFiles[i];
          restoreOperations.add(_storage.writeJson(targetFile, data));
          restoreFiles.add(targetFile);
        } else {
          debugPrint('Failed to load backup data from: ${existingBackups[i]}');
        }
      }
      
      if (restoreOperations.isEmpty) {
        debugPrint('No valid backup data found to restore');
        return false;
      }
      
      // Execute all restore writes in parallel
      final restoreResults = await Future.wait(restoreOperations);
      
      // Check results
      bool allSuccessful = true;
      for (int i = 0; i < restoreResults.length; i++) {
        if (!restoreResults[i]) {
          debugPrint('Failed to restore: ${restoreFiles[i]}');
          allSuccessful = false;
        }
      }
      
      if (allSuccessful) {
        debugPrint('Successfully restored ${restoreFiles.length} files from backup suffix: $backupSuffix');
      }
      
      return allSuccessful;
      
    } catch (e) {
      debugPrint('Error during backup restoration: $e');
      return false;
    }
  }

  // Initialize with default content if files don't exist
  Future<bool> initializeDefaultContent() async {
    if (!_initialized) return false;
    
    bool anyInitialized = false;
    
    // Check each content type and initialize with empty arrays if missing
    final contentChecks = await checkContentFilesExist();
    
    for (final entry in contentChecks.entries) {
      final fileName = entry.key;
      final exists = entry.value;
      
      if (!exists) {
        try {
          Map<String, dynamic> defaultData;
          
          // Create appropriate default content based on file type
          if (fileName == 'spells.json') {
            defaultData = {
              'spells': <Map<String, dynamic>>[],
              'lastUpdated': DateTime.now().toIso8601String(),
              'count': 0,
            };
          } else if (fileName == 'groups.json') {
            defaultData = {
              'groups': <String>[],
              'lastUpdated': DateTime.now().toIso8601String(),
            };
          } else if (fileName == 'languages.json') {
            defaultData = {
              'languages': <String>[],
              'lastUpdated': DateTime.now().toIso8601String(),
            };
          } else {
            // For other content types (feats, races, classes, etc.)
            final contentKey = fileName.replaceAll('.json', '');
            defaultData = {
              contentKey: <Map<String, dynamic>>[],
              'lastUpdated': DateTime.now().toIso8601String(),
            };
          }
          
          final success = await _storage.writeJson(fileName, defaultData);
          if (success) {
            debugPrint('Initialized default content for $fileName');
            anyInitialized = true;
          } else {
            debugPrint('Failed to initialize default content for $fileName');
          }
        } catch (e) {
          debugPrint('Error initializing default content for $fileName: $e');
        }
      }
    }
    
    return anyInitialized;
  }

  // Reset service (clear instance for testing)
  static void resetInstance() {
    _instance = null;
  }
}
