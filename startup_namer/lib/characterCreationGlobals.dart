import "globals.dart";
import 'package:flutter/material.dart';

class AbilityScore {
  int value;
  String name;

  AbilityScore({required this.name, required this.value});
}

AbilityScore strength = AbilityScore(name: "Strength", value: 8);
AbilityScore dexterity = AbilityScore(name: "Dexterity", value: 8);
AbilityScore constitution = AbilityScore(name: "Constitution", value: 8);
AbilityScore intelligence = AbilityScore(name: "Intelligence", value: 8);
AbilityScore wisdom = AbilityScore(name: "Wisdom", value: 8);
AbilityScore charisma = AbilityScore(name: "Charisma", value: 8);
int pointsRemaining = 27;
//STR/DEX/CON/INT/WIS/CHAR

//const MainCreateCharacter({Key? key}) //: super(key: key);
Spell spellExample = list.first;
String? levellingMethod;
Race initialRace = RACELIST.first;
List<int> abilityScoreIncreases = RACELIST.first.raceScoreIncrease;
Subrace? subraceExample;
//options in the initial menu initialised

bool? featsAllowed = false;
bool? averageHitPoints = false;
bool? multiclassing = false;
bool? milestoneLevelling = false;
bool? myCustomContent = false;
bool? optionalClassFeatures = false;
bool? criticalRoleContent = false;
bool? encumberanceRules = false;
bool? includeCoinsForWeight = false;
bool? unearthedArcanaContent = false;
bool? firearmsUsable = false;
bool? extraFeatAtLevel1 = false;
String? characterLevel = "1";
List<List<bool>>? optionalOnesStates = [];
List<Widget> optionalOnes = [];
List<Widget> listings =
    List<Widget>.filled(RACELIST.first.mystery1S, const Text("jklfjkgj"));
List<bool> isSelected = [false, false, false, false, false, false];
