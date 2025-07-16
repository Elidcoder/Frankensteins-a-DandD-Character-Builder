import 'package:flutter/foundation.dart';
import 'content_storage_service.dart';
import '../../content_classes/srd_globals.dart';
import '../../content_classes/non_character_classes/spell/spell.dart';
import '../../content_classes/non_character_classes/class/class.dart';
import '../../content_classes/non_character_classes/race/race.dart';
import '../../content_classes/non_character_classes/feat/feat.dart';
import '../../content_classes/non_character_classes/item/item.dart';
import '../../content_classes/non_character_classes/background/background.dart';
import '../../content_classes/non_character_classes/proficiency.dart';
import '../../colour_scheme_class/colour_scheme.dart';
import '../../file_manager/file_manager.dart';

/// Dual Write Manager - Manages writing to both legacy and new storage systems
/// During transition period, all writes go to both systems for safety
/// Reads can be configured to prefer new system with fallback to legacy
class DualWriteManager {
  static final DualWriteManager _instance = DualWriteManager._internal();
  static DualWriteManager get instance => _instance;
  DualWriteManager._internal();
  
  // Configuration flags
  bool _dualWriteEnabled = true;
  bool _newSystemReadEnabled = false;
  bool _enableDetailedLogging = true;
  
  // Operation counters for monitoring
  int _successfulDualWrites = 0;
  int _failedDualWrites = 0;
  int _legacyOnlyWrites = 0;
  int _newOnlyWrites = 0;
  
  // ==================== Configuration Methods ====================
  
  /// Enable/disable dual write mode
  void setDualWriteEnabled(bool enabled) {
    _dualWriteEnabled = enabled;
    _log('Dual write ${enabled ? 'enabled' : 'disabled'}');
  }
  
  /// Enable/disable reading from new system (with legacy fallback)
  void setNewSystemReadEnabled(bool enabled) {
    _newSystemReadEnabled = enabled;
    _log('New system read ${enabled ? 'enabled' : 'disabled'}');
  }
  
  /// Enable/disable detailed operation logging
  void setDetailedLogging(bool enabled) {
    _enableDetailedLogging = enabled;
  }
  
  /// Get current configuration
  Map<String, dynamic> getConfiguration() {
    return {
      'dualWriteEnabled': _dualWriteEnabled,
      'newSystemReadEnabled': _newSystemReadEnabled,
      'detailedLogging': _enableDetailedLogging,
      'stats': getOperationStats(),
    };
  }
  
  /// Get operation statistics
  Map<String, int> getOperationStats() {
    // Note: Read operations on individual ints are atomic in Dart
    return {
      'successfulDualWrites': _successfulDualWrites,
      'failedDualWrites': _failedDualWrites,
      'legacyOnlyWrites': _legacyOnlyWrites,
      'newOnlyWrites': _newOnlyWrites,
    };
  }
  
  /// Reset operation counters
  void resetStats() {
    // Note: Assignment operations on individual ints are atomic in Dart
    _successfulDualWrites = 0;
    _failedDualWrites = 0;
    _legacyOnlyWrites = 0;
    _newOnlyWrites = 0;
    _log('Operation statistics reset');
  }
  
  // ==================== Dual Write Operations ====================
  
  /// Write spells to both systems
  Future<DualWriteResult> writeSpells(List<Spell> spells) async {
    _log('Writing ${spells.length} spells');
    
    bool legacySuccess = !_dualWriteEnabled; // ✅ Only true if legacy write not attempted
    bool newSuccess = true;
    String? legacyError;
    String? newError;
    
    // Write to legacy system (update global list + save)
    if (_dualWriteEnabled) {
      try {
        SPELLLIST.clear();
        SPELLLIST.addAll(spells);
        await saveChanges(); // Call existing file_manager save
        _log('Legacy spell write: SUCCESS');
      } catch (e) {
        legacySuccess = false;
        legacyError = e.toString();
        _log('Legacy spell write: FAILED - $e');
      }
    }
    
    // Write to new system
    try {
      newSuccess = await ContentStorageService.saveSpells(spells);
      if (!newSuccess) {
        newError = 'saveSpells returned false - operation failed';
        _log('New spell write: FAILED - saveSpells returned false');
      } else {
        _log('New spell write: SUCCESS');
      }
    } catch (e) {
      newSuccess = false;
      newError = e.toString();
      _log('New spell write: FAILED - $e');
    }
    
    return _recordResult(legacySuccess, newSuccess, 'spells', legacyError, newError);
  }
  
  /// Write classes to both systems
  Future<DualWriteResult> writeClasses(List<Class> classes) async {
    _log('Writing ${classes.length} classes');
    
    bool legacySuccess = !_dualWriteEnabled; // ✅ Fixed logic
    bool newSuccess = true;
    String? legacyError;
    String? newError;
    
    if (_dualWriteEnabled) {
      try {
        CLASSLIST.clear();
        CLASSLIST.addAll(classes);
        await saveChanges();
        _log('Legacy class write: SUCCESS');
      } catch (e) {
        legacySuccess = false;
        legacyError = e.toString();
        _log('Legacy class write: FAILED - $e');
      }
    }
    
    try {
      newSuccess = await ContentStorageService.saveClasses(classes);
      if (!newSuccess) {
        newError = 'saveClasses returned false - operation failed';
        _log('New class write: FAILED - saveClasses returned false');
      } else {
        _log('New class write: SUCCESS');
      }
    } catch (e) {
      newSuccess = false;
      newError = e.toString();
      _log('New class write: FAILED - $e');
    }
    
    return _recordResult(legacySuccess, newSuccess, 'classes', legacyError, newError);
  }
  
  /// Write races to both systems
  Future<DualWriteResult> writeRaces(List<Race> races) async {
    _log('Writing ${races.length} races');
    
    bool legacySuccess = !_dualWriteEnabled; // ✅ Fixed logic
    bool newSuccess = true;
    String? legacyError;
    String? newError;
    
    if (_dualWriteEnabled) {
      try {
        RACELIST.clear();
        RACELIST.addAll(races);
        await saveChanges();
        _log('Legacy race write: SUCCESS');
      } catch (e) {
        legacySuccess = false;
        legacyError = e.toString();
        _log('Legacy race write: FAILED - $e');
      }
    }
    
    try {
      newSuccess = await ContentStorageService.saveRaces(races);
      if (!newSuccess) {
        newError = 'saveRaces returned false - operation failed';
        _log('New race write: FAILED - saveRaces returned false');
      } else {
        _log('New race write: SUCCESS');
      }
    } catch (e) {
      newSuccess = false;
      newError = e.toString();
      _log('New race write: FAILED - $e');
    }
    
    return _recordResult(legacySuccess, newSuccess, 'races', legacyError, newError);
  }
  
  /// Write feats to both systems
  Future<DualWriteResult> writeFeats(List<Feat> feats) async {
    _log('Writing ${feats.length} feats');
    
    bool legacySuccess = !_dualWriteEnabled; // ✅ Fixed logic
    bool newSuccess = true;
    String? legacyError;
    String? newError;
    
    if (_dualWriteEnabled) {
      try {
        FEATLIST.clear();
        FEATLIST.addAll(feats);
        await saveChanges();
        _log('Legacy feat write: SUCCESS');
      } catch (e) {
        legacySuccess = false;
        legacyError = e.toString();
        _log('Legacy feat write: FAILED - $e');
      }
    }
    
    try {
      newSuccess = await ContentStorageService.saveFeats(feats);
      if (!newSuccess) {
        newError = 'saveFeats returned false - operation failed';
        _log('New feat write: FAILED - saveFeats returned false');
      } else {
        _log('New feat write: SUCCESS');
      }
    } catch (e) {
      newSuccess = false;
      newError = e.toString();
      _log('New feat write: FAILED - $e');
    }
    
    return _recordResult(legacySuccess, newSuccess, 'feats', legacyError, newError);
  }
  
  /// Write items to both systems
  Future<DualWriteResult> writeItems(List<Item> items) async {
    _log('Writing ${items.length} items');
    
    bool legacySuccess = !_dualWriteEnabled; // ✅ Fixed logic
    bool newSuccess = true;
    String? legacyError;
    String? newError;
    
    if (_dualWriteEnabled) {
      try {
        ITEMLIST.clear();
        ITEMLIST.addAll(items);
        await saveChanges();
        _log('Legacy item write: SUCCESS');
      } catch (e) {
        legacySuccess = false;
        legacyError = e.toString();
        _log('Legacy item write: FAILED - $e');
      }
    }
    
    try {
      newSuccess = await ContentStorageService.saveItems(items);
      if (!newSuccess) {
        newError = 'saveItems returned false - operation failed';
        _log('New item write: FAILED - saveItems returned false');
      } else {
        _log('New item write: SUCCESS');
      }
    } catch (e) {
      newSuccess = false;
      newError = e.toString();
      _log('New item write: FAILED - $e');
    }
    
    return _recordResult(legacySuccess, newSuccess, 'items', legacyError, newError);
  }
  
  /// Write backgrounds to both systems
  Future<DualWriteResult> writeBackgrounds(List<Background> backgrounds) async {
    _log('Writing ${backgrounds.length} backgrounds');
    
    bool legacySuccess = !_dualWriteEnabled; // ✅ Fixed logic
    bool newSuccess = true;
    String? legacyError;
    String? newError;
    
    if (_dualWriteEnabled) {
      try {
        BACKGROUNDLIST.clear();
        BACKGROUNDLIST.addAll(backgrounds);
        await saveChanges();
        _log('Legacy background write: SUCCESS');
      } catch (e) {
        legacySuccess = false;
        legacyError = e.toString();
        _log('Legacy background write: FAILED - $e');
      }
    }
    
    try {
      newSuccess = await ContentStorageService.saveBackgrounds(backgrounds);
      if (!newSuccess) {
        newError = 'saveBackgrounds returned false - operation failed';
        _log('New background write: FAILED - saveBackgrounds returned false');
      } else {
        _log('New background write: SUCCESS');
      }
    } catch (e) {
      newSuccess = false;
      newError = e.toString();
      _log('New background write: FAILED - $e');
    }
    
    return _recordResult(legacySuccess, newSuccess, 'backgrounds', legacyError, newError);
  }
  
  /// Write proficiencies to both systems
  Future<DualWriteResult> writeProficiencies(List<Proficiency> proficiencies) async {
    _log('Writing ${proficiencies.length} proficiencies');
    
    bool legacySuccess = !_dualWriteEnabled; // ✅ Fixed logic
    bool newSuccess = true;
    String? legacyError;
    String? newError;
    
    if (_dualWriteEnabled) {
      try {
        PROFICIENCYLIST.clear();
        PROFICIENCYLIST.addAll(proficiencies);
        await saveChanges();
        _log('Legacy proficiency write: SUCCESS');
      } catch (e) {
        legacySuccess = false;
        legacyError = e.toString();
        _log('Legacy proficiency write: FAILED - $e');
      }
    }
    
    try {
      newSuccess = await ContentStorageService.saveProficiencies(proficiencies);
      if (!newSuccess) {
        newError = 'saveProficiencies returned false - operation failed';
        _log('New proficiency write: FAILED - saveProficiencies returned false');
      } else {
        _log('New proficiency write: SUCCESS');
      }
    } catch (e) {
      newSuccess = false;
      newError = e.toString();
      _log('New proficiency write: FAILED - $e');
    }
    
    return _recordResult(legacySuccess, newSuccess, 'proficiencies', legacyError, newError);
  }
  
  /// Write languages to both systems
  Future<DualWriteResult> writeLanguages(List<String> languages) async {
    _log('Writing ${languages.length} languages');
    
    bool legacySuccess = !_dualWriteEnabled; // ✅ Fixed logic
    bool newSuccess = true;
    String? legacyError;
    String? newError;
    
    if (_dualWriteEnabled) {
      try {
        LANGUAGELIST.clear();
        LANGUAGELIST.addAll(languages);
        await saveChanges();
        _log('Legacy language write: SUCCESS');
      } catch (e) {
        legacySuccess = false;
        legacyError = e.toString();
        _log('Legacy language write: FAILED - $e');
      }
    }
    
    try {
      newSuccess = await ContentStorageService.saveLanguages(languages);
      if (!newSuccess) {
        newError = 'saveLanguages returned false - operation failed';
        _log('New language write: FAILED - saveLanguages returned false');
      } else {
        _log('New language write: SUCCESS');
      }
    } catch (e) {
      newSuccess = false;
      newError = e.toString();
      _log('New language write: FAILED - $e');
    }
    
    return _recordResult(legacySuccess, newSuccess, 'languages', legacyError, newError);
  }
  
  /// Write themes to both systems
  Future<DualWriteResult> writeThemes(List<ColourScheme> themes) async {
    _log('Writing ${themes.length} themes');
    
    bool legacySuccess = !_dualWriteEnabled; // ✅ Fixed logic
    bool newSuccess = true;
    String? legacyError;
    String? newError;
    
    if (_dualWriteEnabled) {
      try {
        THEMELIST.clear();
        THEMELIST.addAll(themes);
        await saveChanges();
        _log('Legacy theme write: SUCCESS');
      } catch (e) {
        legacySuccess = false;
        legacyError = e.toString();
        _log('Legacy theme write: FAILED - $e');
      }
    }
    
    try {
      newSuccess = await ContentStorageService.saveThemes(themes);
      if (!newSuccess) {
        newError = 'saveThemes returned false - operation failed';
        _log('New theme write: FAILED - saveThemes returned false');
      } else {
        _log('New theme write: SUCCESS');
      }
    } catch (e) {
      newSuccess = false;
      newError = e.toString();
      _log('New theme write: FAILED - $e');
    }
    
    return _recordResult(legacySuccess, newSuccess, 'themes', legacyError, newError);
  }
  
  /// Write all content to both systems
  Future<Map<String, DualWriteResult>> writeAllContent() async {
    _log('Writing all content to both systems');
    
    final results = <String, DualWriteResult>{};
    
    results['spells'] = await writeSpells(SPELLLIST);
    results['classes'] = await writeClasses(CLASSLIST);
    results['races'] = await writeRaces(RACELIST);
    results['feats'] = await writeFeats(FEATLIST);
    results['items'] = await writeItems(ITEMLIST);
    results['backgrounds'] = await writeBackgrounds(BACKGROUNDLIST);
    results['proficiencies'] = await writeProficiencies(PROFICIENCYLIST);
    results['languages'] = await writeLanguages(LANGUAGELIST);
    results['themes'] = await writeThemes(THEMELIST);
    
    return results;
  }
  
  // ==================== Dual Read Operations ====================
  
  /// Read spells from new system with legacy fallback
  Future<List<Spell>> readSpells() async {
    if (_newSystemReadEnabled) {
      try {
        final spells = await ContentStorageService.loadSpells();
        if (spells.isNotEmpty) {
          _log('Read ${spells.length} spells from NEW system');
          return spells;
        }
        _log('New system returned empty spells, falling back to legacy');
      } catch (e) {
        _log('New system spell read failed: $e, falling back to legacy');
      }
    }
    
    // Fallback to legacy system
    _log('Reading ${SPELLLIST.length} spells from LEGACY system');
    return List<Spell>.from(SPELLLIST);
  }
  
  /// Read classes from new system with legacy fallback
  Future<List<Class>> readClasses() async {
    if (_newSystemReadEnabled) {
      try {
        final classes = await ContentStorageService.loadClasses();
        if (classes.isNotEmpty) {
          _log('Read ${classes.length} classes from NEW system');
          return classes;
        }
        _log('New system returned empty classes, falling back to legacy');
      } catch (e) {
        _log('New system class read failed: $e, falling back to legacy');
      }
    }
    
    _log('Reading ${CLASSLIST.length} classes from LEGACY system');
    return List<Class>.from(CLASSLIST);
  }
  
  /// Read races from new system with legacy fallback
  Future<List<Race>> readRaces() async {
    if (_newSystemReadEnabled) {
      try {
        final races = await ContentStorageService.loadRaces();
        if (races.isNotEmpty) {
          _log('Read ${races.length} races from NEW system');
          return races;
        }
        _log('New system returned empty races, falling back to legacy');
      } catch (e) {
        _log('New system race read failed: $e, falling back to legacy');
      }
    }
    
    _log('Reading ${RACELIST.length} races from LEGACY system');
    return List<Race>.from(RACELIST);
  }
  
  /// Read feats from new system with legacy fallback
  Future<List<Feat>> readFeats() async {
    if (_newSystemReadEnabled) {
      try {
        final feats = await ContentStorageService.loadFeats();
        if (feats.isNotEmpty) {
          _log('Read ${feats.length} feats from NEW system');
          return feats;
        }
        _log('New system returned empty feats, falling back to legacy');
      } catch (e) {
        _log('New system feat read failed: $e, falling back to legacy');
      }
    }
    
    _log('Reading ${FEATLIST.length} feats from LEGACY system');
    return List<Feat>.from(FEATLIST);
  }
  
  /// Read items from new system with legacy fallback
  Future<List<Item>> readItems() async {
    if (_newSystemReadEnabled) {
      try {
        final items = await ContentStorageService.loadItems();
        if (items.isNotEmpty) {
          _log('Read ${items.length} items from NEW system');
          return items;
        }
        _log('New system returned empty items, falling back to legacy');
      } catch (e) {
        _log('New system item read failed: $e, falling back to legacy');
      }
    }
    
    _log('Reading ${ITEMLIST.length} items from LEGACY system');
    return List<Item>.from(ITEMLIST);
  }
  
  /// Read backgrounds from new system with legacy fallback
  Future<List<Background>> readBackgrounds() async {
    if (_newSystemReadEnabled) {
      try {
        final backgrounds = await ContentStorageService.loadBackgrounds();
        if (backgrounds.isNotEmpty) {
          _log('Read ${backgrounds.length} backgrounds from NEW system');
          return backgrounds;
        }
        _log('New system returned empty backgrounds, falling back to legacy');
      } catch (e) {
        _log('New system background read failed: $e, falling back to legacy');
      }
    }
    
    _log('Reading ${BACKGROUNDLIST.length} backgrounds from LEGACY system');
    return List<Background>.from(BACKGROUNDLIST);
  }
  
  /// Read proficiencies from new system with legacy fallback
  Future<List<Proficiency>> readProficiencies() async {
    if (_newSystemReadEnabled) {
      try {
        final proficiencies = await ContentStorageService.loadProficiencies();
        if (proficiencies.isNotEmpty) {
          _log('Read ${proficiencies.length} proficiencies from NEW system');
          return proficiencies;
        }
        _log('New system returned empty proficiencies, falling back to legacy');
      } catch (e) {
        _log('New system proficiency read failed: $e, falling back to legacy');
      }
    }
    
    _log('Reading ${PROFICIENCYLIST.length} proficiencies from LEGACY system');
    return List<Proficiency>.from(PROFICIENCYLIST);
  }
  
  /// Read languages from new system with legacy fallback
  Future<List<String>> readLanguages() async {
    if (_newSystemReadEnabled) {
      try {
        final languages = await ContentStorageService.loadLanguages();
        if (languages.isNotEmpty) {
          _log('Read ${languages.length} languages from NEW system');
          return languages;
        }
        _log('New system returned empty languages, falling back to legacy');
      } catch (e) {
        _log('New system language read failed: $e, falling back to legacy');
      }
    }
    
    _log('Reading ${LANGUAGELIST.length} languages from LEGACY system');
    return List<String>.from(LANGUAGELIST);
  }
  
  /// Read themes from new system with legacy fallback
  Future<List<ColourScheme>> readThemes() async {
    if (_newSystemReadEnabled) {
      try {
        final themes = await ContentStorageService.loadThemes();
        if (themes.isNotEmpty) {
          _log('Read ${themes.length} themes from NEW system');
          return themes;
        }
        _log('New system returned empty themes, falling back to legacy');
      } catch (e) {
        _log('New system theme read failed: $e, falling back to legacy');
      }
    }
    
    _log('Reading ${THEMELIST.length} themes from LEGACY system');
    return List<ColourScheme>.from(THEMELIST);
  }
  
  // ==================== Utility Methods ====================
  
  /// Sync current global lists to new system (initial migration)
  Future<Map<String, DualWriteResult>> syncLegacyToNew() async {
    _log('Syncing all legacy data to new system');
    
    final results = <String, DualWriteResult>{};
    
    // Temporarily disable dual write to avoid circular calls
    final originalDualWrite = _dualWriteEnabled;
    _dualWriteEnabled = false;
    
    try {
      results['spells'] = await writeSpells(SPELLLIST);
      results['classes'] = await writeClasses(CLASSLIST);
      results['races'] = await writeRaces(RACELIST);
      results['feats'] = await writeFeats(FEATLIST);
      results['items'] = await writeItems(ITEMLIST);
      results['backgrounds'] = await writeBackgrounds(BACKGROUNDLIST);
      results['proficiencies'] = await writeProficiencies(PROFICIENCYLIST);
      results['languages'] = await writeLanguages(LANGUAGELIST);
      results['themes'] = await writeThemes(THEMELIST);
      
      _log('Legacy to new sync completed');
    } finally {
      _dualWriteEnabled = originalDualWrite;
    }
    
    return results;
  }
  
  /// Verify data consistency between systems
  Future<Map<String, ConsistencyResult>> verifyConsistency() async {
    _log('Verifying data consistency between systems');
    
    final results = <String, ConsistencyResult>{};
    
    // Compare spells
    try {
      final newSpells = await ContentStorageService.loadSpells();
      results['spells'] = ConsistencyResult(
        contentType: 'spells',
        legacyCount: SPELLLIST.length,
        newCount: newSpells.length,
        consistent: SPELLLIST.length == newSpells.length,
      );
    } catch (e) {
      results['spells'] = ConsistencyResult(
        contentType: 'spells',
        legacyCount: SPELLLIST.length,
        newCount: 0,
        consistent: false,
        error: e.toString(),
      );
    }
    
    // Compare classes
    try {
      final newClasses = await ContentStorageService.loadClasses();
      results['classes'] = ConsistencyResult(
        contentType: 'classes',
        legacyCount: CLASSLIST.length,
        newCount: newClasses.length,
        consistent: CLASSLIST.length == newClasses.length,
      );
    } catch (e) {
      results['classes'] = ConsistencyResult(
        contentType: 'classes',
        legacyCount: CLASSLIST.length,
        newCount: 0,
        consistent: false,
        error: e.toString(),
      );
    }
    
    // Compare races
    try {
      final newRaces = await ContentStorageService.loadRaces();
      results['races'] = ConsistencyResult(
        contentType: 'races',
        legacyCount: RACELIST.length,
        newCount: newRaces.length,
        consistent: RACELIST.length == newRaces.length,
      );
    } catch (e) {
      results['races'] = ConsistencyResult(
        contentType: 'races',
        legacyCount: RACELIST.length,
        newCount: 0,
        consistent: false,
        error: e.toString(),
      );
    }
    
    // Compare feats
    try {
      final newFeats = await ContentStorageService.loadFeats();
      results['feats'] = ConsistencyResult(
        contentType: 'feats',
        legacyCount: FEATLIST.length,
        newCount: newFeats.length,
        consistent: FEATLIST.length == newFeats.length,
      );
    } catch (e) {
      results['feats'] = ConsistencyResult(
        contentType: 'feats',
        legacyCount: FEATLIST.length,
        newCount: 0,
        consistent: false,
        error: e.toString(),
      );
    }
    
    // Compare items
    try {
      final newItems = await ContentStorageService.loadItems();
      results['items'] = ConsistencyResult(
        contentType: 'items',
        legacyCount: ITEMLIST.length,
        newCount: newItems.length,
        consistent: ITEMLIST.length == newItems.length,
      );
    } catch (e) {
      results['items'] = ConsistencyResult(
        contentType: 'items',
        legacyCount: ITEMLIST.length,
        newCount: 0,
        consistent: false,
        error: e.toString(),
      );
    }
    
    // Compare backgrounds
    try {
      final newBackgrounds = await ContentStorageService.loadBackgrounds();
      results['backgrounds'] = ConsistencyResult(
        contentType: 'backgrounds',
        legacyCount: BACKGROUNDLIST.length,
        newCount: newBackgrounds.length,
        consistent: BACKGROUNDLIST.length == newBackgrounds.length,
      );
    } catch (e) {
      results['backgrounds'] = ConsistencyResult(
        contentType: 'backgrounds',
        legacyCount: BACKGROUNDLIST.length,
        newCount: 0,
        consistent: false,
        error: e.toString(),
      );
    }
    
    // Compare proficiencies
    try {
      final newProficiencies = await ContentStorageService.loadProficiencies();
      results['proficiencies'] = ConsistencyResult(
        contentType: 'proficiencies',
        legacyCount: PROFICIENCYLIST.length,
        newCount: newProficiencies.length,
        consistent: PROFICIENCYLIST.length == newProficiencies.length,
      );
    } catch (e) {
      results['proficiencies'] = ConsistencyResult(
        contentType: 'proficiencies',
        legacyCount: PROFICIENCYLIST.length,
        newCount: 0,
        consistent: false,
        error: e.toString(),
      );
    }
    
    // Compare languages
    try {
      final newLanguages = await ContentStorageService.loadLanguages();
      results['languages'] = ConsistencyResult(
        contentType: 'languages',
        legacyCount: LANGUAGELIST.length,
        newCount: newLanguages.length,
        consistent: LANGUAGELIST.length == newLanguages.length,
      );
    } catch (e) {
      results['languages'] = ConsistencyResult(
        contentType: 'languages',
        legacyCount: LANGUAGELIST.length,
        newCount: 0,
        consistent: false,
        error: e.toString(),
      );
    }
    
    // Compare themes
    try {
      final newThemes = await ContentStorageService.loadThemes();
      results['themes'] = ConsistencyResult(
        contentType: 'themes',
        legacyCount: THEMELIST.length,
        newCount: newThemes.length,
        consistent: THEMELIST.length == newThemes.length,
      );
    } catch (e) {
      results['themes'] = ConsistencyResult(
        contentType: 'themes',
        legacyCount: THEMELIST.length,
        newCount: 0,
        consistent: false,
        error: e.toString(),
      );
    }
    
    return results;
  }
  
  // ==================== Private Methods ====================
  
  DualWriteResult _recordResult(
    bool legacySuccess,
    bool newSuccess,
    String contentType,
    String? legacyError,
    String? newError,
  ) {
    final result = DualWriteResult(
      contentType: contentType,
      legacySuccess: legacySuccess,
      newSuccess: newSuccess,
      legacyError: legacyError,
      newError: newError,
    );
    
    // Update statistics based on actual write attempts
    if (_dualWriteEnabled) {
      // Dual write mode
      if (legacySuccess && newSuccess) {
        _successfulDualWrites++;
      } else {
        _failedDualWrites++;
      }
      
      if (legacySuccess && !newSuccess) {
        _legacyOnlyWrites++;
      } else if (!legacySuccess && newSuccess) {
        _newOnlyWrites++;
      }
    } else {
      // New system only mode
      if (newSuccess) {
        _newOnlyWrites++;
      } else {
        _failedDualWrites++;
      }
    }
    
    return result;
  }
  
  void _log(String message) {
    if (_enableDetailedLogging) {
      debugPrint('[DualWriteManager] $message');
    }
  }
}

/// Result of a dual write operation
class DualWriteResult {
  final String contentType;
  final bool legacySuccess;
  final bool newSuccess;
  final String? legacyError;
  final String? newError;
  
  const DualWriteResult({
    required this.contentType,
    required this.legacySuccess,
    required this.newSuccess,
    this.legacyError,
    this.newError,
  });
  
  bool get overallSuccess => legacySuccess || newSuccess;
  bool get bothSucceeded => legacySuccess && newSuccess;
  bool get anyFailed => !legacySuccess || !newSuccess;
  
  @override
  String toString() {
    return 'DualWriteResult($contentType: legacy=${legacySuccess ? "✅" : "❌"}, new=${newSuccess ? "✅" : "❌"})';
  }
}

/// Result of consistency verification
class ConsistencyResult {
  final String contentType;
  final int legacyCount;
  final int newCount;
  final bool consistent;
  final String? error;
  
  const ConsistencyResult({
    required this.contentType,
    required this.legacyCount,
    required this.newCount,
    required this.consistent,
    this.error,
  });
  
  @override
  String toString() {
    return 'ConsistencyResult($contentType: legacy=$legacyCount, new=$newCount, consistent=$consistent)';
  }
}
