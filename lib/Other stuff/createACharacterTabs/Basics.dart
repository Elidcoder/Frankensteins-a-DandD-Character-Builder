import 'package:flutter/material.dart';
import 'package:frankenstein/Other%20stuff/createACharacterTabs/character_creation_globals.dart';

class GetBasicsPage extends StatefulWidget {
  @override
  BasicsPage createState() => BasicsPage();
}

class BasicsPage extends State<GetBasicsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),
        Row(
          children: [
            Expanded(
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                  Container(
                    width: 280,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(
                        color: const Color.fromARGB(255, 7, 26, 239),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                        child: Text(
                      textAlign: TextAlign.center,
                      "Character info",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      width: 250,
                      height: 50,
                      child: TextField(
                          cursorColor: Colors.blue,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Enter character's name",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 212, 208, 224)),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 124, 112, 112),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12))))),
                  //ask level or exp
                  //add switch + list tittle stuff for lvl/exp
                  const SizedBox(height: 15),
                  SizedBox(
                      width: 250,
                      height: 50,
                      child: TextField(
                          cursorColor: Colors.blue,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Enter the player's name",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 212, 208, 224)),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 124, 112, 112),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12))))),
                  const SizedBox(height: 15),
                  SizedBox(
                      width: 250,
                      height: 50,
                      child: TextField(
                          cursorColor: Colors.blue,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Enter the character's gender",
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 212, 208, 224)),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 124, 112, 112),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12))))),
                  const SizedBox(height: 15),
                  SizedBox(
                      width: 300,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RadioListTile(
                              title: const Text("Use experience"),
                              value: "Experience",
                              groupValue: levellingMethod,
                              onChanged: (value) {
                                setState(() {
                                  levellingMethod = value.toString();
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            Container(
                                child: levellingMethod == "Experience"
                                    ? SizedBox(
                                        width: 250,
                                        height: 50,
                                        child: TextField(
                                            cursorColor: Colors.blue,
                                            style: const TextStyle(
                                                color: Colors.white),
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Enter the character's exp",
                                                hintStyle: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 212, 208, 224)),
                                                filled: true,
                                                fillColor: const Color.fromARGB(
                                                    255, 124, 112, 112),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)))))
                                    : RadioListTile(
                                        title: const Text("Use levels"),
                                        value: "Levels",
                                        groupValue: levellingMethod,
                                        onChanged: (value) {
                                          setState(() {
                                            levellingMethod = value.toString();
                                          });
                                        },
                                      )),
                            const SizedBox(height: 5),
                            Container(
                              child: levellingMethod == "Experience"
                                  ? RadioListTile(
                                      title: const Text("Use levels"),
                                      value: "Levels",
                                      groupValue: levellingMethod,
                                      onChanged: (value) {
                                        setState(() {
                                          levellingMethod = value.toString();
                                        });
                                      },
                                    )
                                  : SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: DropdownButton<String>(
                                        value: characterLevel,
                                        icon: const Icon(Icons.arrow_drop_down,
                                            color: Color.fromARGB(
                                                255, 7, 26, 239)),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20),
                                        underline: Container(
                                          height: 2,
                                          color: const Color.fromARGB(
                                              255, 7, 26, 239),
                                        ),
                                        onChanged: (String? value) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            characterLevel = value!;
                                          });
                                        },
                                        items: [
                                          "1",
                                          "2",
                                          "3",
                                          "4",
                                          "5",
                                          "6",
                                          "7",
                                          "8",
                                          "9",
                                          "10",
                                          "11",
                                          "12",
                                          "13",
                                          "14",
                                          "15",
                                          "16",
                                          "17",
                                          "18",
                                          "19",
                                          "20"
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Center(child: Text(value)),
                                          );
                                        }).toList(),
                                      )),
                            ),
                            const SizedBox(height: 10),
                          ]))
                ])),
            Expanded(
                child: Column(
              children: [
                Container(
                  width: 325,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(
                      color: const Color.fromARGB(255, 7, 26, 239),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                      child: Text(
                    textAlign: TextAlign.center,
                    "Build Parameters",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 325,
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: const Text('Feats in use'),
                        value: featsAllowed,
                        onChanged: (bool? value) {
                          setState(() {
                            featsAllowed = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 15),
                      CheckboxListTile(
                        title: const Text('Use average for hit dice'),
                        value: averageHitPoints,
                        onChanged: (bool? value) {
                          setState(() {
                            averageHitPoints = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 15),
                      CheckboxListTile(
                        title: const Text('Allow multiclassing'),
                        value: multiclassing,
                        onChanged: (bool? value) {
                          setState(() {
                            multiclassing = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 15),
                      CheckboxListTile(
                        title: const Text('Use milestone levelling'),
                        value: milestoneLevelling,
                        onChanged: (bool? value) {
                          setState(() {
                            milestoneLevelling = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 15),
                      CheckboxListTile(
                        title: const Text('Use created content'),
                        value: myCustomContent,
                        onChanged: (bool? value) {
                          setState(() {
                            myCustomContent = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 15),
                      CheckboxListTile(
                        title: const Text('Use optional class features'),
                        value: optionalClassFeatures,
                        onChanged: (bool? value) {
                          setState(() {
                            optionalClassFeatures = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                Container(
                  width: 325,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(
                      color: const Color.fromARGB(255, 7, 26, 239),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                      child: Text(
                    textAlign: TextAlign.center,
                    "Rarer Parameters",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 325,
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: const Text('Use critical role content'),
                        value: criticalRoleContent,
                        onChanged: (bool? value) {
                          setState(() {
                            criticalRoleContent = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 15),
                      CheckboxListTile(
                        title: const Text('Use encumberance rules'),
                        value: encumberanceRules,
                        onChanged: (bool? value) {
                          setState(() {
                            encumberanceRules = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 15),
                      CheckboxListTile(
                        title: const Text("Incude coins' weights"),
                        value: includeCoinsForWeight,
                        onChanged: (bool? value) {
                          setState(() {
                            includeCoinsForWeight = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 15),
                      CheckboxListTile(
                        title: const Text('Use UA content'),
                        value: unearthedArcanaContent,
                        onChanged: (bool? value) {
                          setState(() {
                            unearthedArcanaContent = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 15),
                      CheckboxListTile(
                        title: const Text('Allow firearms'),
                        value: firearmsUsable,
                        onChanged: (bool? value) {
                          setState(() {
                            firearmsUsable = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 15),
                      CheckboxListTile(
                        title: const Text('Give an extra feat at lvl 1'),
                        value: extraFeatAtLevel1,
                        onChanged: (bool? value) {
                          setState(() {
                            extraFeatAtLevel1 = value;
                          });
                        },
                        secondary: const Icon(Icons.insert_photo),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ))
          ],
        )
      ],
    );
  }
}
