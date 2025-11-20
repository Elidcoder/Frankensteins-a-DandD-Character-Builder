// External Imports
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/services/global_list_manager.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/utils/style_utils.dart';
import '../../../models/content/base/content.dart';

/// Screen for selecting and exporting content to a JSON file
class ExportContent extends StatefulWidget {
  const ExportContent({super.key});

  @override
  State<ExportContent> createState() => _ExportContentState();
}

class _ExportContentState extends State<ExportContent> {
  String searchTerm = "";
  late Future<void> _initialisedContent;

  // Track selected content for each category
  final Set<String> _selectedSpells = {};
  final Set<String> _selectedClasses = {};
  final Set<String> _selectedRaces = {};
  final Set<String> _selectedFeats = {};
  final Set<String> _selectedItems = {};
  final Set<String> _selectedBackgrounds = {};

  // Track collapsed state for each category
  final Set<String> _collapsed = {};

  @override
  void initState() {
    super.initState();
    _initialisedContent = GlobalListManager().initialiseContentLists();
    ThemeManager.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {
      // Rebuild when theme changes
    });
  }

  int get _totalSelected =>
      _selectedSpells.length +
      _selectedClasses.length +
      _selectedRaces.length +
      _selectedFeats.length +
      _selectedItems.length +
      _selectedBackgrounds.length;

  @override
  Widget build(BuildContext context) {
    return StyleUtils.styledFutureBuilder(
        future: _initialisedContent,
        builder: (context) => Scaffold(
              appBar: StyleUtils.buildStyledAppBar(
                title: "Export content",
                titleStyle: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  color: ThemeManager.instance.currentScheme.textColour,
                ),
              ),
              backgroundColor:
                  ThemeManager.instance.currentScheme.backgroundColour,
              floatingActionButton: _totalSelected > 0
                  ? SizedBox(
                      width: 200,
                      height: 70,
                      child: FloatingActionButton.extended(
                        onPressed: () => _handleExport(context),
                        backgroundColor:
                            ThemeManager.instance.currentScheme.backingColour,
                        icon: Icon(
                          Icons.upload_file,
                          size: 32,
                          color: ThemeManager.instance.currentScheme.textColour,
                        ),
                        label: Text(
                          'Export ($_totalSelected)',
                          style: TextStyle(
                            color:
                                ThemeManager.instance.currentScheme.textColour,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  : null,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* Search bar */
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchTerm = value;
                        });
                      },
                      decoration: StyleUtils.buildDefaultInputDecoration(
                        hintText: "Search content to export",
                        prefixIcon: Icon(Icons.search,
                            color:
                                ThemeManager.instance.currentScheme.textColour),
                      ),
                    ),
                  ),

                  /* Content list */
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /* Spells */
                          _buildCategorySection(
                            "Spells",
                            GlobalListManager().spellList,
                            _selectedSpells,
                          ),

                          /* Classes */
                          _buildCategorySection(
                            "Classes",
                            GlobalListManager().classList,
                            _selectedClasses,
                          ),

                          /* Races */
                          _buildCategorySection(
                            "Races",
                            GlobalListManager().raceList,
                            _selectedRaces,
                          ),

                          /* Feats */
                          _buildCategorySection(
                            "Feats",
                            GlobalListManager().featList,
                            _selectedFeats,
                          ),

                          /* Items */
                          _buildCategorySection(
                            "Items",
                            GlobalListManager().itemList,
                            _selectedItems,
                          ),

                          /* Backgrounds */
                          _buildCategorySection(
                            "Backgrounds",
                            GlobalListManager().backgroundList,
                            _selectedBackgrounds,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget _buildCategorySection(
      String title, List<Content> contentList, Set<String> selectedSet) {
    final filtered = contentList.where((item) {
      final query = searchTerm.toLowerCase();
      return item.name.toLowerCase().contains(query);
    }).toList();

    if (filtered.isEmpty) {
      return const SizedBox.shrink();
    }

    final categorySelectedCount =
        filtered.where((item) => selectedSet.contains(item.name)).length;
    final isCollapsed = _collapsed.contains(title);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.5,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: ThemeManager.instance.currentScheme.backingColour,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /* Title  */
                  Expanded(
                      flex: 8,
                      child: StyleUtils.buildStyledMediumTextBox(
                        text: title,
                      )),
                  /* Buttons */
                  Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StyleUtils.buildStyledSmallTextBox(
                              text:
                                  '$categorySelectedCount / ${filtered.length}'),
                          /* Select/Deselect all button */
                          StyleUtils.buildStyledOutlinedButton(
                              fontSize: categorySelectedCount != filtered.length
                                  ? 15
                                  : 18,
                              borderWidth:
                                  categorySelectedCount != filtered.length
                                      ? 1.5
                                      : 2.5,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              text: categorySelectedCount == filtered.length
                                  ? 'Deselect All'
                                  : 'Select All',
                              onPressed: () {
                                setState(() {
                                  if (categorySelectedCount ==
                                      filtered.length) {
                                    // Deselect all
                                    for (var item in filtered) {
                                      selectedSet.remove(item.name);
                                    }
                                  } else {
                                    // Select all
                                    for (var item in filtered) {
                                      selectedSet.add(item.name);
                                    }
                                  }
                                });
                              },
                              backgroundColor:
                                  categorySelectedCount == filtered.length
                                      ? positiveColor
                                      : ThemeManager.instance.currentScheme
                                          .backgroundColour,
                              textColor: ThemeManager
                                  .instance.currentScheme.backingColour),
                          /* Minimize/Expand button */
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: ThemeManager
                                  .instance.currentScheme.backgroundColour,
                              side: const BorderSide(
                                  color: Colors.black, width: 1.5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 1),
                            ),
                            onPressed: () {
                              setState(() {
                                if (isCollapsed) {
                                  _collapsed.remove(title);
                                } else {
                                  _collapsed.add(title);
                                }
                              });
                            },
                            child: Icon(
                              isCollapsed
                                  ? Icons.expand_more
                                  : Icons.expand_less,
                              color: ThemeManager
                                  .instance.currentScheme.textColour,
                              size: 30,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),

        /* Content items - only show if not collapsed */
        if (!isCollapsed)
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.33,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 220,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      _buildContentCard(filtered[index], selectedSet),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContentCard(Content item, Set<String> selectedSet) {
    final isSelected = selectedSet.contains(item.name);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: ThemeManager.instance.currentScheme.backingColour,
          side: BorderSide(
            color: Colors.black,
            width: isSelected ? 2.5 : 1.5,
          ),
          padding: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            if (isSelected) {
              selectedSet.remove(item.name);
            } else {
              selectedSet.add(item.name);
            }
          });
        },
        child: Row(
          children: [
            Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: isSelected,
                  activeColor: positiveColor,
                  checkColor: Colors.white,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedSet.add(item.name);
                      } else {
                        selectedSet.remove(item.name);
                      }
                    });
                  },
                )),
            const SizedBox(width: 14),
            /* Content info */
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ThemeManager.instance.currentScheme.textColour,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.sourceBook,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: ThemeManager.instance.currentScheme.textColour
                          .withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExport(BuildContext context) async {
    // Build the JSON structure matching loadContentFromFile format
    final exportData = {
      "Spells": GlobalListManager()
          .spellList
          .where((spell) => _selectedSpells.contains(spell.name))
          .map((spell) => spell.toJson())
          .toList(),
      "Classes": GlobalListManager()
          .classList
          .where((cls) => _selectedClasses.contains(cls.name))
          .map((cls) => cls.toJson())
          .toList(),
      "Races": GlobalListManager()
          .raceList
          .where((race) => _selectedRaces.contains(race.name))
          .map((race) => race.toJson())
          .toList(),
      "Feats": GlobalListManager()
          .featList
          .where((feat) => _selectedFeats.contains(feat.name))
          .map((feat) => feat.toJson())
          .toList(),
      "Equipment": GlobalListManager()
          .itemList
          .where((item) => _selectedItems.contains(item.name))
          .map((item) => item.toJson())
          .toList(),
      "Backgrounds": GlobalListManager()
          .backgroundList
          .where((bg) => _selectedBackgrounds.contains(bg.name))
          .map((bg) => bg.toJson())
          .toList(),
      "Proficiencies": [],
      "Languages": [],
      "ColourSchemes": [],
    };

    // Convert to pretty-printed JSON
    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

    try {
      // Let user choose where to save
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save exported content',
        fileName: 'exported_content.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) {
        // User cancelled
        return;
      }

      // Write the file
      final file = File(result);
      await file.writeAsString(jsonString);

      // Show success and navigate back
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Successfully exported $_totalSelected items to ${result.split(Platform.pathSeparator).last}'),
            duration: const Duration(seconds: 3),
            backgroundColor: positiveColor,
          ),
        );
      }
    } catch (err) {
      // Show error
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => StyleUtils.buildStyledAlertDialog(
            title: "Error",
            content: err.toString(),
            titleWidget: StyleUtils.buildStyledLargeTextBox(
              text: "Failed to export content",
              color: Colors.red,
            ),
            actions: [
              StyleUtils.buildStyledTextButton(
                text: "OK",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }
}
