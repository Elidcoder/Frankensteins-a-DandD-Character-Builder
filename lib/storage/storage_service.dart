import "package:frankenstein/models/index.dart";

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

  Future<List<Character>> getAllCharacters();
  Future<bool> updateCharacter(Character character);
  Future<bool> saveCharacter(Character character);
  Future<bool> deleteCharacter(int characterId); 
}
