// External Imports
import "package:flutter/foundation.dart" show debugPrint;

// Project Import
import "../colour_scheme_class/colour_scheme.dart";
import "../content_classes/all_content_classes.dart";
import "../services/character_migration_helper.dart";
import "../services/storage/content_storage_service.dart";

List<Character> CHARACTERLIST = [];
List<String> GROUPLIST = [];

/* initialiseGlobals reads the new storage system and updates the LISTS. */
Future<bool> initialiseGlobals() async {
  // Check if content is already loaded to shortcircuit initialization (do not need to check every list, an app loading without these is highly unlikely)
  if (SPELLLIST.isNotEmpty || CLASSLIST.isNotEmpty || RACELIST.isNotEmpty) {
    return true;
  }
    
  try {
    // Initialize the new storage system
    await ContentStorageService.initialize();
    
    // Load all content from the new multi-file storage system
    SPELLLIST.addAll(await ContentStorageService.loadSpells());
    CLASSLIST.addAll(await ContentStorageService.loadClasses());
    RACELIST.addAll(await ContentStorageService.loadRaces());
    FEATLIST.addAll(await ContentStorageService.loadFeats());
    ITEMLIST.addAll(await ContentStorageService.loadItems());
    BACKGROUNDLIST.addAll(await ContentStorageService.loadBackgrounds());
    PROFICIENCYLIST.addAll(await ContentStorageService.loadProficiencies());
    LANGUAGELIST.addAll(await ContentStorageService.loadLanguages());
    THEMELIST.addAll(await ContentStorageService.loadThemes());
    
    debugPrint('Content loaded from new storage system:');
    debugPrint('- Spells: ${SPELLLIST.length}');
    debugPrint('- Classes: ${CLASSLIST.length}');
    debugPrint('- Races: ${RACELIST.length}');
    debugPrint('- Feats: ${FEATLIST.length}');
    debugPrint('- Items: ${ITEMLIST.length}');
    debugPrint('- Backgrounds: ${BACKGROUNDLIST.length}');
    debugPrint('- Proficiencies: ${PROFICIENCYLIST.length}');
    debugPrint('- Languages: ${LANGUAGELIST.length}');
    debugPrint('- Themes: ${THEMELIST.length}');
    
    return true;

  /* Update failure */
  } catch (e) {
    debugPrint('Failed to initialize from new storage system: $e');
    return false;
  }
}

/* Save the changes using the new multi-file storage system. */
Future<void> saveChanges() async {
  try {
    // Save to new storage system using ContentStorageService directly
    final results = await Future.wait([
      ContentStorageService.saveSpells(SPELLLIST),
      ContentStorageService.saveClasses(CLASSLIST),
      ContentStorageService.saveRaces(RACELIST),
      ContentStorageService.saveFeats(FEATLIST),
      ContentStorageService.saveItems(ITEMLIST),
      ContentStorageService.saveBackgrounds(BACKGROUNDLIST),
      ContentStorageService.saveProficiencies(PROFICIENCYLIST),
      ContentStorageService.saveLanguages(LANGUAGELIST),
      ContentStorageService.saveThemes(THEMELIST),
    ]);
    
    // Count successes
    final successCount = results.where((result) => result).length;
    final failCount = results.length - successCount;
    
    debugPrint('Content save completed: $successCount successes, $failCount failures');
    
    if (failCount > 0) {
      debugPrint('Warning: $failCount content types failed to save');
    }

  /* Error in saving changes, reset globals to undo bad change. */
  } catch (e) {
    debugPrint('Critical save failure: $e, resetting globals');
    GROUPLIST.clear();
    LANGUAGELIST.clear();
    FEATLIST.clear();
    RACELIST.clear();
    SPELLLIST.clear();
    CLASSLIST.clear();
    ITEMLIST.clear();
    CHARACTERLIST.clear();
    BACKGROUNDLIST.clear();
    THEMELIST.clear();
    PROFICIENCYLIST.clear();
    await initialiseGlobals();
  }
}

/* Update GROUPLIST from the new character storage system */
Future<void> updateGroupListFromNewSystem() async {
  try {
    // Get all characters from the new system
    final characters = await CharacterMigrationHelper.getAllCharacters();
    
    // Extract unique groups from characters efficiently
    final groups = characters
      .map((c) => c.group)
      .where((group) => group != null && group.trim().isNotEmpty)
      .cast<String>()
      .toSet()
      .toList()
      ..sort();
    
    // Update the global GROUPLIST
    GROUPLIST.clear();
    GROUPLIST.addAll(groups);
    
    // Debug output for verification
    debugPrint('Updated GROUPLIST with ${GROUPLIST.length} groups from ${characters.length} characters');
  } catch (e) {
    debugPrint('Error updating GROUPLIST from new system: $e');
    // Keep existing GROUPLIST if update fails
  }
}
