// External Import
import "package:flutter/material.dart";

// Project Imports
import "../../widgets/top_bar.dart";
import "../../theme/theme_manager.dart";
import "../../utils/style_utils.dart";

/* Serves as a linker page between the main page and the users choice of content to create. */
class CustomContent extends StatelessWidget {
  const CustomContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* Page title (Create content) */
      appBar: StyleUtils.buildStyledAppBar(
        title: "Create content",
        titleStyle: TextStyle(
          fontSize: 45, 
          fontWeight: FontWeight.w700,
          color: ThemeManager.instance.currentScheme.textColour,
        ),
      ),
      backgroundColor: ThemeManager.instance.currentScheme.backgroundColour,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /* Button taking the user to the create custom spells page */
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: ThemeManager.instance.currentScheme.backingColour,
                  padding: const EdgeInsets.fromLTRB(55, 25, 55, 25),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  side: const BorderSide(width: 3, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegularTop(pagechoice: "Create spells")),
                  );
                },
                child: Text(
                  textAlign: TextAlign.center,
                  "Create a\nspell",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, color: ThemeManager.instance.currentScheme.textColour),
                ),
              ),
            ],
          ),
        ],
      ));
  }
}
