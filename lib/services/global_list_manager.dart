// External Imports
import "package:flutter/foundation.dart" show debugPrint;

// Project Imports
import "../colour_scheme_class/colour_scheme.dart";
import "../content_classes/all_content_classes.dart";
import "../services/character_storage_service.dart";
import "../services/storage/content_storage_service.dart";

/// Global list manager that handles initialization and access to all game content lists
class GlobalListManager {
  static final GlobalListManager _instance = GlobalListManager._internal();
  factory GlobalListManager() => _instance;
  GlobalListManager._internal();

  // Content lists
  List<Spell> _spellList = [];
  List<Class> _classList = [];
  List<Race> _raceList = [];
  List<Feat> _featList = [];
  List<Item> _itemList = [];
  List<Background> _backgroundList = [];
  List<Proficiency> _proficiencyList = [];
  List<String> _languageList = [];
  List<ColourScheme> _themeList = [];
  List<Character> _characterList = [];
  List<String> _groupList = [];

  // Initialization flags
  bool _spellsInitialized = false;
  bool _classesInitialized = false;
  bool _racesInitialized = false;
  bool _featsInitialized = false;
  bool _itemsInitialized = false;
  bool _backgroundsInitialized = false;
  bool _proficienciesInitialized = false;
  bool _languagesInitialized = false;
  bool _themesInitialized = false;
  bool _charactersInitialized = false;
  bool _groupsInitialized = false;

  /// Initialize both content and character storage systems
  Future<bool> initialise() async {
    try {
      await ContentStorageService.initialize();
      await CharacterStorageService.initialize();
      return true;
    } catch (e) {
      debugPrint('Failed to initialize storage systems: $e');
      return false;
    }
  }

  /// Initialize spell list
  Future<List<Spell>> initialiseSpellList() async {
    if (_spellsInitialized) return _spellList;
    
    _spellList = await ContentStorageService.loadSpells();
    _spellsInitialized = true;
    debugPrint('Initialized spell list with ${_spellList.length} spells');
    return _spellList;
  }

  /// Initialize class list
  Future<List<Class>> initialiseClassList() async {
    if (_classesInitialized) return _classList;
    
    _classList = await ContentStorageService.loadClasses();
    _classesInitialized = true;
    debugPrint('Initialized class list with ${_classList.length} classes');
    return _classList;
  }

  /// Initialize race list
  Future<List<Race>> initialiseRaceList() async {
    if (_racesInitialized) return _raceList;
    
    _raceList = await ContentStorageService.loadRaces();
    _racesInitialized = true;
    debugPrint('Initialized race list with ${_raceList.length} races');
    return _raceList;
  }

  /// Initialize feat list
  Future<List<Feat>> initialiseFeatList() async {
    if (_featsInitialized) return _featList;
    
    _featList = await ContentStorageService.loadFeats();
    _featsInitialized = true;
    debugPrint('Initialized feat list with ${_featList.length} feats');
    return _featList;
  }

  /// Initialize item list
  Future<List<Item>> initialiseItemList() async {
    if (_itemsInitialized) return _itemList;
    
    _itemList = await ContentStorageService.loadItems();
    _itemsInitialized = true;
    debugPrint('Initialized item list with ${_itemList.length} items');
    return _itemList;
  }

  /// Initialize background list
  Future<List<Background>> initialiseBackgroundList() async {
    if (_backgroundsInitialized) return _backgroundList;
    
    _backgroundList = await ContentStorageService.loadBackgrounds();
    _backgroundsInitialized = true;
    debugPrint('Initialized background list with ${_backgroundList.length} backgrounds');
    return _backgroundList;
  }

  /// Initialize proficiency list
  Future<List<Proficiency>> initialiseProficiencyList() async {
    if (_proficienciesInitialized) return _proficiencyList;
    
    _proficiencyList = await ContentStorageService.loadProficiencies();
    _proficienciesInitialized = true;
    debugPrint('Initialized proficiency list with ${_proficiencyList.length} proficiencies');
    return _proficiencyList;
  }

  /// Initialize language list
  Future<List<String>> initialiseLanguageList() async {
    if (_languagesInitialized) return _languageList;
    
    _languageList = await ContentStorageService.loadLanguages();
    _languagesInitialized = true;
    debugPrint('Initialized language list with ${_languageList.length} languages');
    return _languageList;
  }

  /// Initialize theme list
  Future<List<ColourScheme>> initialiseThemeList() async {
    if (_themesInitialized) return _themeList;
    
    _themeList = await ContentStorageService.loadThemes();
    _themesInitialized = true;
    debugPrint('Initialized theme list with ${_themeList.length} themes');
    return _themeList;
  }

  /// Initialize character list
  Future<List<Character>> initialiseCharacterList() async {
    if (_charactersInitialized) return _characterList;
    
    _characterList = await CharacterStorageService.getAllCharacters();
    _charactersInitialized = true;
    debugPrint('Initialized character list with ${_characterList.length} characters');
    
    // Automatically initialize groups when characters are loaded
    _updateGroupList();
    
    return _characterList;
  }

  /// Update group list from current character list (internal method)
  void _updateGroupList() {
    final groups = _characterList
        .map((c) => c.group)
        .where((group) => group != null && group.trim().isNotEmpty)
        .cast<String>()
        .toSet()
        .toList()
      ..sort();
    
    _groupList = groups;
    _groupsInitialized = true;
    debugPrint('Updated group list with ${_groupList.length} groups');
  }

  /// Get spell list (crashes if not initialized)
  List<Spell> getSpellList() {
    if (!_spellsInitialized) {
      throw StateError('Spell list not initialized. Call initialiseSpellList() first.');
    }
    return _spellList;
  }

  /// Get class list (crashes if not initialized)
  List<Class> getClassList() {
    if (!_classesInitialized) {
      throw StateError('Class list not initialized. Call initialiseClassList() first.');
    }
    return _classList;
  }

  /// Get race list (crashes if not initialized)
  List<Race> getRaceList() {
    if (!_racesInitialized) {
      throw StateError('Race list not initialized. Call initialiseRaceList() first.');
    }
    return _raceList;
  }

  /// Get feat list (crashes if not initialized)
  List<Feat> getFeatList() {
    if (!_featsInitialized) {
      throw StateError('Feat list not initialized. Call initialiseFeatList() first.');
    }
    return _featList;
  }

  /// Get item list (crashes if not initialized)
  List<Item> getItemList() {
    if (!_itemsInitialized) {
      throw StateError('Item list not initialized. Call initialiseItemList() first.');
    }
    return _itemList;
  }

  /// Get background list (crashes if not initialized)
  List<Background> getBackgroundList() {
    if (!_backgroundsInitialized) {
      throw StateError('Background list not initialized. Call initialiseBackgroundList() first.');
    }
    return _backgroundList;
  }

  /// Get proficiency list (crashes if not initialized)
  List<Proficiency> getProficiencyList() {
    if (!_proficienciesInitialized) {
      throw StateError('Proficiency list not initialized. Call initialiseProficiencyList() first.');
    }
    return _proficiencyList;
  }

  /// Get language list (crashes if not initialized)
  List<String> getLanguageList() {
    if (!_languagesInitialized) {
      throw StateError('Language list not initialized. Call initialiseLanguageList() first.');
    }
    return _languageList;
  }

  /// Get theme list (crashes if not initialized)
  List<ColourScheme> getThemeList() {
    if (!_themesInitialized) {
      throw StateError('Theme list not initialized. Call initialiseThemeList() first.');
    }
    return _themeList;
  }

  /// Get character list (crashes if not initialized)
  List<Character> getCharacterList() {
    if (!_charactersInitialized) {
      throw StateError('Character list not initialized. Call initialiseCharacterList() first.');
    }
    return _characterList;
  }

  /// Get group list (crashes if not initialized)
  List<String> getGroupList() {
    if (!_groupsInitialized) {
      throw StateError('Group list not initialized. Call initialiseGroupList() first.');
    }
    return _groupList;
  }
}
