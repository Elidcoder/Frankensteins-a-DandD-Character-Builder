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
    
    try {
      _spellList = await ContentStorageService.loadSpells();
      _spellsInitialized = true;
      debugPrint('Initialized spell list with ${_spellList.length} spells');
      return _spellList;
    } catch (e) {
      debugPrint('Failed to initialize spell list: $e');
      rethrow;
    }
  }

  /// Initialize class list
  Future<List<Class>> initialiseClassList() async {
    if (_classesInitialized) return _classList;
    
    try {
      _classList = await ContentStorageService.loadClasses();
      _classesInitialized = true;
      debugPrint('Initialized class list with ${_classList.length} classes');
      return _classList;
    } catch (e) {
      debugPrint('Failed to initialize class list: $e');
      rethrow;
    }
  }

  /// Initialize race list
  Future<List<Race>> initialiseRaceList() async {
    if (_racesInitialized) return _raceList;
    
    try {
      _raceList = await ContentStorageService.loadRaces();
      _racesInitialized = true;
      debugPrint('Initialized race list with ${_raceList.length} races');
      return _raceList;
    } catch (e) {
      debugPrint('Failed to initialize race list: $e');
      rethrow;
    }
  }

  /// Initialize feat list
  Future<List<Feat>> initialiseFeatList() async {
    if (_featsInitialized) return _featList;
    
    try {
      _featList = await ContentStorageService.loadFeats();
      _featsInitialized = true;
      debugPrint('Initialized feat list with ${_featList.length} feats');
      return _featList;
    } catch (e) {
      debugPrint('Failed to initialize feat list: $e');
      rethrow;
    }
  }

  /// Initialize item list
  Future<List<Item>> initialiseItemList() async {
    if (_itemsInitialized) return _itemList;
    
    try {
      _itemList = await ContentStorageService.loadItems();
      _itemsInitialized = true;
      debugPrint('Initialized item list with ${_itemList.length} items');
      return _itemList;
    } catch (e) {
      debugPrint('Failed to initialize item list: $e');
      rethrow;
    }
  }

  /// Initialize background list
  Future<List<Background>> initialiseBackgroundList() async {
    if (_backgroundsInitialized) return _backgroundList;
    
    try {
      _backgroundList = await ContentStorageService.loadBackgrounds();
      _backgroundsInitialized = true;
      debugPrint('Initialized background list with ${_backgroundList.length} backgrounds');
      return _backgroundList;
    } catch (e) {
      debugPrint('Failed to initialize background list: $e');
      rethrow;
    }
  }

  /// Initialize proficiency list
  Future<List<Proficiency>> initialiseProficiencyList() async {
    if (_proficienciesInitialized) return _proficiencyList;
    
    try {
      _proficiencyList = await ContentStorageService.loadProficiencies();
      _proficienciesInitialized = true;
      debugPrint('Initialized proficiency list with ${_proficiencyList.length} proficiencies');
      return _proficiencyList;
    } catch (e) {
      debugPrint('Failed to initialize proficiency list: $e');
      rethrow;
    }
  }

  /// Initialize language list
  Future<List<String>> initialiseLanguageList() async {
    if (_languagesInitialized) return _languageList;
    
    try {
      _languageList = await ContentStorageService.loadLanguages();
      _languagesInitialized = true;
      debugPrint('Initialized language list with ${_languageList.length} languages');
      return _languageList;
    } catch (e) {
      debugPrint('Failed to initialize language list: $e');
      rethrow;
    }
  }

  /// Initialize theme list
  Future<List<ColourScheme>> initialiseThemeList() async {
    if (_themesInitialized) return _themeList;
    
    try {
      _themeList = await ContentStorageService.loadThemes();
      _themesInitialized = true;
      debugPrint('Initialized theme list with ${_themeList.length} themes');
      return _themeList;
    } catch (e) {
      debugPrint('Failed to initialize theme list: $e');
      rethrow;
    }
  }

  /// Initialize character list
  Future<List<Character>> initialiseCharacterList() async {
    if (_charactersInitialized) return _characterList;
    
    try {
      _characterList = await CharacterStorageService.getAllCharacters();
      _charactersInitialized = true;
      debugPrint('Initialized character list with ${_characterList.length} characters');
      
      // Automatically initialize groups when characters are loaded
      _updateGroupList();
      
      return _characterList;
    } catch (e) {
      debugPrint('Failed to initialize character list: $e');
      rethrow;
    }
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

  /// Spell list getter (crashes if not initialized)
  List<Spell> get spellList {
    if (!_spellsInitialized) {
      throw StateError('Spell list not initialized. Call initialiseSpellList() first.');
    }
    return _spellList;
  }

  /// Class list getter (crashes if not initialized)
  List<Class> get classList {
    if (!_classesInitialized) {
      throw StateError('Class list not initialized. Call initialiseClassList() first.');
    }
    return _classList;
  }

  /// Race list getter (crashes if not initialized)
  List<Race> get raceList {
    if (!_racesInitialized) {
      throw StateError('Race list not initialized. Call initialiseRaceList() first.');
    }
    return _raceList;
  }

  /// Feat list getter (crashes if not initialized)
  List<Feat> get featList {
    if (!_featsInitialized) {
      throw StateError('Feat list not initialized. Call initialiseFeatList() first.');
    }
    return _featList;
  }

  /// Item list getter (crashes if not initialized)
  List<Item> get itemList {
    if (!_itemsInitialized) {
      throw StateError('Item list not initialized. Call initialiseItemList() first.');
    }
    return _itemList;
  }

  /// Background list getter (crashes if not initialized)
  List<Background> get backgroundList {
    if (!_backgroundsInitialized) {
      throw StateError('Background list not initialized. Call initialiseBackgroundList() first.');
    }
    return _backgroundList;
  }

  /// Proficiency list getter (crashes if not initialized)
  List<Proficiency> get proficiencyList {
    if (!_proficienciesInitialized) {
      throw StateError('Proficiency list not initialized. Call initialiseProficiencyList() first.');
    }
    return _proficiencyList;
  }

  /// Language list getter (crashes if not initialized)
  List<String> get languageList {
    if (!_languagesInitialized) {
      throw StateError('Language list not initialized. Call initialiseLanguageList() first.');
    }
    return _languageList;
  }

  /// Theme list getter (crashes if not initialized)
  List<ColourScheme> get themeList {
    if (!_themesInitialized) {
      throw StateError('Theme list not initialized. Call initialiseThemeList() first.');
    }
    return _themeList;
  }

  /// Character list getter (crashes if not initialized)
  List<Character> get characterList {
    if (!_charactersInitialized) {
      throw StateError('Character list not initialized. Call initialiseCharacterList() first.');
    }
    return _characterList;
  }

  /// Group list getter (crashes if not initialized)
  List<String> get groupList {
    if (!_groupsInitialized) {
      throw StateError('Group list not initialized. Call initialiseCharacterList() first.');
    }
    return _groupList;
  }

  void initialiseContentLists() {
    //TODO()
    //TODO()
    //TODO()
  }
}
