import 'package:frankenstein/colour_scheme_class/colour_scheme.dart' show ColourScheme;
import 'package:frankenstein/content_classes/non_character_classes/background/background.dart' show Background;
import 'package:frankenstein/content_classes/non_character_classes/class/class.dart' show Class;
import 'package:frankenstein/content_classes/non_character_classes/feat/feat.dart' show Feat;
import 'package:frankenstein/content_classes/non_character_classes/item/item.dart' show Item;
import 'package:frankenstein/content_classes/non_character_classes/proficiency.dart' show Proficiency;
import 'package:frankenstein/content_classes/non_character_classes/race/race.dart' show Race;
import 'package:frankenstein/content_classes/non_character_classes/spell/spell.dart' show Spell;

abstract interface class StorageService {
  Future<void> initialize();

  Future<List<Background>> loadBackgrounds();
  Future<List<Class>> loadClasses();
  Future<List<Feat>> loadFeats();
  Future<List<Item>> loadItems();
  Future<List<String>> loadLanguages();
  Future<List<Proficiency>> loadProficiencies();
  Future<List<Race>> loadRaces();
  Future<List<Spell>> loadSpells();
  Future<List<ColourScheme>> loadThemes();

  Future<bool> saveBackgrounds(List<Background> backgrounds);
  Future<bool> saveClasses(List<Class> classes);
  Future<bool> saveFeats(List<Feat> feats);
  Future<bool> saveItems(List<Item> items);
  Future<bool> saveLanguages(List<String> languages);
  Future<bool> saveProficiencies(List<Proficiency> proficiencies);
  Future<bool> saveRaces(List<Race> races);
  Future<bool> saveSpells(List<Spell> spells);
  Future<bool> saveThemes(List<ColourScheme> themes);
}
