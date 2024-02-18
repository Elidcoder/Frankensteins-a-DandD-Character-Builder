1) Currently only part of create a character is working - nothing else
2) when editing the SRD.json ensure you follow the class requirements (can be found in the globals.dart file) as there is no checks and the app will just crash
3) hierachy of proficiencies is:
    0) armour, weapon, skill, shield
    1) skill (actual), martial, simple, gun, L/M/H armour
    2) ranged, melee, gun (actual),  armour (actual)
    3) weapon (actual)