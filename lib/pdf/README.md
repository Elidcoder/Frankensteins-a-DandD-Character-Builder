# PDF Character Sheet Generator

A modular PDF generation system for D&D 5e character sheet generation. This system employs a **Domain-Specific Language (DSL) approach** for clean, maintainable PDF composition.

## Architecture Overview

The PDF generator follows a layered, component-based architecture that separates concerns and promotes code reusability:

```
lib/pdf/
├── generator.dart         # Main entry point
├── display.dart           # Preview widget
├── utils.dart             # Shared utilities & constants
└── first_page/            # Page-specific components
    ├── page.dart          # Page assembly & layout
    ...                    # Page specific components
```

## Result

![PDF for a character](../../docs/images/pdf/demo_character.png)

### DSL-Style Component System
This system uses a **declarative, composable approach** similar to modern UI frameworks:

```dart
// Clean, readable component composition
Widget buildAbilityScore(String name, AbilityScore score) {
  return Container(
    child: Column(
      children: [
        Text(name, style: boldHeader),
        buildModifierBox(score),
        buildScoreDisplay(score.value),
      ],
    ),
  );
}
```

### Modular Page Assembly
Pages are assembled from focused components:

```dart
Widget buildSkillLine(String skillName, Ability ability, bool isProficient) {
  return Container(
    height: 13,
    child: Row(
      children: [
        buildProficiencyIndicator(isProficient),
        buildModifierText(calculateModifier(ability, isProficient)),
        buildSkillNameText(skillName),
        buildAbilityLabel(ability),
      ],
    ),
  );
}
```

### Data-Driven Rendering
```dart
// All D&D skills rendered from clean data structure
final skillMappings = {
  'Acrobatics': Ability.DEXTERITY,
  'Animal Handling': Ability.WISDOM,
  'Arcana': Ability.INTELLIGENCE,
  // ...
};

// Generate skill lines programmatically
...skillMappings.entries.map((entry) => 
  buildSkillLine(entry.key, entry.value, isSkillProficient(entry.key))
).toList(),
```

## Core Dependencies
- **pdf**: PDF document generation
- **printing**: Preview and print functionality
- **flutter**: SDK integration

## Future Enhancements

- [ ] **Multi-page support**: Add more pages to generated PDFs
