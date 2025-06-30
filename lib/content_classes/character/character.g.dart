// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      skillBonusMap: Map<String, int>.from(json['skillBonusMap'] as Map),
      levelsPerClass: (json['levelsPerClass'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      allSelected: json['allSelected'] as List<dynamic>,
      classSubclassMapper:
          Map<String, String>.from(json['classSubclassMapper'] as Map),
      ACList: (json['ACList'] as List<dynamic>)
          .map((e) => e as List<dynamic>)
          .toList(),
      allSpellsSelected: (json['allSpellsSelected'] as List<dynamic>)
          .map((e) => Spell.fromJson(e as Map<String, dynamic>))
          .toList(),
      allSpellsSelectedAsListsOfThings:
          (json['allSpellsSelectedAsListsOfThings'] as List<dynamic>)
              .map((e) => e as List<dynamic>)
              .toList(),
      armourList: (json['armourList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      featsSelected: (json['featsSelected'] as List<dynamic>)
          .map((e) => e as List<dynamic>)
          .toList(),
      itemList:
          (json['itemList'] as List<dynamic>).map((e) => e as String).toList(),
      equipmentSelectedFromChoices:
          json['equipmentSelectedFromChoices'] as List<dynamic>,
      optionalOnesStates: (json['optionalOnesStates'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as bool).toList())
          .toList(),
      optionalTwosStates: (json['optionalTwosStates'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as bool).toList())
          .toList(),
      speedBonuses: (json['speedBonuses'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      weaponList: (json['weaponList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      unstackableEquipmentSelected:
          json['unstackableEquipmentSelected'] as List<dynamic>,
      featuresAndTraits: (json['featuresAndTraits'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      languagesKnown: (json['languagesKnown'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      classList:
          (json['classList'] as List<dynamic>).map((e) => e as String).toList(),
      stackableEquipmentSelected:
          Map<String, int>.from(json['stackableEquipmentSelected'] as Map),
      skillsSelected: _queueFromJson(json['skillsSelected'] as List?),
      languageChoices: _queueFromJson(json['languageChoices'] as List?),
      mainToolProficiencies: (json['mainToolProficiencies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      savingThrowProficiencies:
          (json['savingThrowProficiencies'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      skillProficiencies: (json['skillProficiencies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      background:
          Background.fromJson(json['background'] as Map<String, dynamic>),
      classLevels: (json['classLevels'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      race: Race.fromJson(json['race'] as Map<String, dynamic>),
      backgroundIdeal: json['backgroundIdeal'] as String,
      backgroundPersonalityTrait: json['backgroundPersonalityTrait'] as String,
      backgroundBond: json['backgroundBond'] as String,
      backgroundFlaw: json['backgroundFlaw'] as String,
      raceAbilityScoreIncreases:
          (json['raceAbilityScoreIncreases'] as List<dynamic>)
              .map((e) => (e as num).toInt())
              .toList(),
      strength: AbilityScore.fromJson(json['strength'] as Map<String, dynamic>),
      dexterity:
          AbilityScore.fromJson(json['dexterity'] as Map<String, dynamic>),
      classSkillsSelected: (json['classSkillsSelected'] as List<dynamic>)
          .map((e) => e as bool)
          .toList(),
      constitution:
          AbilityScore.fromJson(json['constitution'] as Map<String, dynamic>),
      intelligence:
          AbilityScore.fromJson(json['intelligence'] as Map<String, dynamic>),
      wisdom: AbilityScore.fromJson(json['wisdom'] as Map<String, dynamic>),
      charisma: AbilityScore.fromJson(json['charisma'] as Map<String, dynamic>),
      featsASIScoreIncreases: (json['featsASIScoreIncreases'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      currency: Map<String, int>.from(json['currency'] as Map),
      characterDescription: CharacterDescription.fromJson(
          json['characterDescription'] as Map<String, dynamic>),
      maxHealth: (json['maxHealth'] as num?)?.toInt() ?? 0,
      characterExperience:
          (json['characterExperience'] as num?)?.toDouble() ?? 0,
      extraFeatures: json['extraFeatures'] as String? ?? "",
      playerName: json['playerName'] as String? ?? "",
      multiclassing: json['multiclassing'] as bool? ?? true,
      featsAllowed: json['featsAllowed'] as bool? ?? true,
      criticalRoleContent: json['criticalRoleContent'] as bool? ?? false,
      encumberanceRules: json['encumberanceRules'] as bool? ?? false,
      extraFeatAtLevel1: json['extraFeatAtLevel1'] as bool? ?? false,
      averageHitPoints: json['averageHitPoints'] as bool? ?? false,
      firearmsUsable: json['firearmsUsable'] as bool? ?? false,
      includeCoinsForWeight: json['includeCoinsForWeight'] as bool? ?? false,
      unearthedArcanaContent: json['unearthedArcanaContent'] as bool? ?? false,
      milestoneLevelling: json['milestoneLevelling'] as bool? ?? false,
      useCustomContent: json['useCustomContent'] as bool? ?? false,
      optionalClassFeatures: json['optionalClassFeatures'] as bool? ?? false,
      inspired: json['inspired'] as bool? ?? false,
      subrace: json['subrace'] == null
          ? null
          : Subrace.fromJson(json['subrace'] as Map<String, dynamic>),
      group: json['group'] as String?,
      uniqueID: (json['uniqueID'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'uniqueID': instance.uniqueID,
      'languagesKnown': instance.languagesKnown,
      'featuresAndTraits': instance.featuresAndTraits,
      'classList': instance.classList,
      'currency': instance.currency,
      'playerName': instance.playerName,
      'classLevels': instance.classLevels,
      'inspired': instance.inspired,
      'mainToolProficiencies': instance.mainToolProficiencies,
      'skillBonusMap': instance.skillBonusMap,
      'skillsSelected': _queueToJson(instance.skillsSelected),
      'languageChoices': _queueToJson(instance.languageChoices),
      'extraFeatures': instance.extraFeatures,
      'speedBonuses': instance.speedBonuses,
      'ACList': instance.ACList,
      'featsAllowed': instance.featsAllowed,
      'averageHitPoints': instance.averageHitPoints,
      'multiclassing': instance.multiclassing,
      'milestoneLevelling': instance.milestoneLevelling,
      'useCustomContent': instance.useCustomContent,
      'optionalClassFeatures': instance.optionalClassFeatures,
      'criticalRoleContent': instance.criticalRoleContent,
      'encumberanceRules': instance.encumberanceRules,
      'includeCoinsForWeight': instance.includeCoinsForWeight,
      'unearthedArcanaContent': instance.unearthedArcanaContent,
      'firearmsUsable': instance.firearmsUsable,
      'extraFeatAtLevel1': instance.extraFeatAtLevel1,
      'savingThrowProficiencies': instance.savingThrowProficiencies,
      'skillProficiencies': instance.skillProficiencies,
      'maxHealth': instance.maxHealth,
      'characterExperience': instance.characterExperience,
      'classSkillsSelected': instance.classSkillsSelected,
      'race': instance.race,
      'subrace': instance.subrace,
      'optionalOnesStates': instance.optionalOnesStates,
      'optionalTwosStates': instance.optionalTwosStates,
      'raceAbilityScoreIncreases': instance.raceAbilityScoreIncreases,
      'background': instance.background,
      'backgroundPersonalityTrait': instance.backgroundPersonalityTrait,
      'backgroundIdeal': instance.backgroundIdeal,
      'backgroundBond': instance.backgroundBond,
      'backgroundFlaw': instance.backgroundFlaw,
      'strength': instance.strength,
      'dexterity': instance.dexterity,
      'constitution': instance.constitution,
      'intelligence': instance.intelligence,
      'wisdom': instance.wisdom,
      'charisma': instance.charisma,
      'levelsPerClass': instance.levelsPerClass,
      'allSelected': instance.allSelected,
      'classSubclassMapper': instance.classSubclassMapper,
      'featsASIScoreIncreases': instance.featsASIScoreIncreases,
      'featsSelected': instance.featsSelected,
      'allSpellsSelected': instance.allSpellsSelected,
      'allSpellsSelectedAsListsOfThings':
          instance.allSpellsSelectedAsListsOfThings,
      'stackableEquipmentSelected': instance.stackableEquipmentSelected,
      'unstackableEquipmentSelected': instance.unstackableEquipmentSelected,
      'armourList': instance.armourList,
      'weaponList': instance.weaponList,
      'itemList': instance.itemList,
      'equipmentSelectedFromChoices': instance.equipmentSelectedFromChoices,
      'characterDescription': instance.characterDescription,
      'group': instance.group,
    };
