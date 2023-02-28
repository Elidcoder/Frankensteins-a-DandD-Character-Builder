import 'package:flutter/material.dart';
import 'package:frankenstein/Other%20stuff/createACharacterTabs/character_creation_globals.dart';

int abilityScoreCost(int x) {
  if (x > 12) {
    return 2;
  }
  return 1;
}

class GetAbilityScorePage extends StatefulWidget {
  @override
  AbilityScorePage createState() => AbilityScorePage();
}

class AbilityScorePage extends State<GetAbilityScorePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          textAlign: TextAlign.center,
          "Points remaining: $pointsRemaining",
          style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 0, 168, 252)),
        ),
        const SizedBox(height: 60),
        Row(
          children: [
            const Expanded(flex: 12, child: SizedBox()),
            Expanded(
                flex: 11,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      strength.name,
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 0, 168, 252)),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 110,
                      width: 116,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(children: [
                        Text(
                          textAlign: TextAlign.center,
                          strength.value.toString(),
                          style: const TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (8 < strength.value && strength.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (strength.value > 8) {
                                          strength.value--;
                                          if (strength.value < 13) {
                                            pointsRemaining++;
                                          } else {
                                            pointsRemaining += 2;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white))
                                : const SizedBox(height: 20, width: 29),
                            (strength.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          (abilityScoreCost(strength.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 10, 126, 54)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (strength.value < 15) {
                                          if (abilityScoreCost(
                                                  strength.value) <=
                                              pointsRemaining) {
                                            pointsRemaining -= abilityScoreCost(
                                                strength.value);
                                            strength.value++;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.add,
                                        color: Colors.white))
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        strength.value--;
                                        pointsRemaining += 2;
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white)),
                          ],
                        )
                      ]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      " (+${abilityScoreIncreases[0]})",
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 7, 26, 239)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        (strength.value + abilityScoreIncreases[0]).toString(),
                        style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 11,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      dexterity.name,
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 0, 168, 252)),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 110,
                      width: 116,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(children: [
                        Text(
                          textAlign: TextAlign.center,
                          dexterity.value.toString(),
                          style: const TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (8 < dexterity.value && dexterity.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (dexterity.value > 8) {
                                          dexterity.value--;
                                          if (dexterity.value < 13) {
                                            pointsRemaining++;
                                          } else {
                                            pointsRemaining += 2;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white))
                                : const SizedBox(height: 20, width: 29),
                            (dexterity.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          (abilityScoreCost(dexterity.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 10, 126, 54)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (dexterity.value < 15) {
                                          if (abilityScoreCost(
                                                  dexterity.value) <=
                                              pointsRemaining) {
                                            pointsRemaining -= abilityScoreCost(
                                                dexterity.value);
                                            dexterity.value++;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.add,
                                        color: Colors.white))
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        dexterity.value--;
                                        pointsRemaining += 2;
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white)),
                          ],
                        )
                      ]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      " (+${abilityScoreIncreases[1]})",
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 7, 26, 239)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        (dexterity.value + abilityScoreIncreases[1]).toString(),
                        style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      constitution.name,
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 0, 168, 252)),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 110,
                      width: 116,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(children: [
                        Text(
                          textAlign: TextAlign.center,
                          constitution.value.toString(),
                          style: const TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (8 < constitution.value && constitution.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (constitution.value > 8) {
                                          constitution.value--;
                                          if (constitution.value < 13) {
                                            pointsRemaining++;
                                          } else {
                                            pointsRemaining += 2;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white))
                                : const SizedBox(height: 20, width: 29),
                            (constitution.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: (abilityScoreCost(
                                                  constitution.value) >
                                              pointsRemaining)
                                          ? const Color.fromARGB(
                                              247, 56, 53, 52)
                                          : const Color.fromARGB(
                                              150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 10, 126, 54)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (constitution.value < 15) {
                                          if (abilityScoreCost(
                                                  constitution.value) <=
                                              pointsRemaining) {
                                            pointsRemaining -= abilityScoreCost(
                                                constitution.value);
                                            constitution.value++;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.add,
                                        color: Colors.white))
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        constitution.value--;
                                        pointsRemaining += 2;
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white)),
                          ],
                        )
                      ]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      " (+${abilityScoreIncreases[2]})",
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 7, 26, 239)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        (constitution.value + abilityScoreIncreases[2])
                            .toString(),
                        style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 13,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      intelligence.name,
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 0, 168, 252)),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 110,
                      width: 116,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(children: [
                        Text(
                          textAlign: TextAlign.center,
                          intelligence.value.toString(),
                          style: const TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (8 < intelligence.value && intelligence.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (intelligence.value > 8) {
                                          intelligence.value--;
                                          if (intelligence.value < 13) {
                                            pointsRemaining++;
                                          } else {
                                            pointsRemaining += 2;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white))
                                : const SizedBox(height: 20, width: 29),
                            (intelligence.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: (abilityScoreCost(
                                                  intelligence.value) >
                                              pointsRemaining)
                                          ? const Color.fromARGB(
                                              247, 56, 53, 52)
                                          : const Color.fromARGB(
                                              150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 10, 126, 54)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (intelligence.value < 15) {
                                          if (abilityScoreCost(
                                                  intelligence.value) <=
                                              pointsRemaining) {
                                            pointsRemaining -= abilityScoreCost(
                                                intelligence.value);
                                            intelligence.value++;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.add,
                                        color: Colors.white))
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        intelligence.value--;
                                        pointsRemaining += 2;
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white)),
                          ],
                        )
                      ]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      " (+${abilityScoreIncreases[3]})",
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 7, 26, 239)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        (intelligence.value + abilityScoreIncreases[3])
                            .toString(),
                        style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      wisdom.name,
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 0, 168, 252)),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 110,
                      width: 116,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(children: [
                        Text(
                          textAlign: TextAlign.center,
                          wisdom.value.toString(),
                          style: const TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (8 < wisdom.value && wisdom.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (wisdom.value > 8) {
                                          wisdom.value--;
                                          if (wisdom.value < 13) {
                                            pointsRemaining++;
                                          } else {
                                            pointsRemaining += 2;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white))
                                : const SizedBox(height: 20, width: 29),
                            (wisdom.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          (abilityScoreCost(wisdom.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 10, 126, 54)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (wisdom.value < 15) {
                                          if (abilityScoreCost(wisdom.value) <=
                                              pointsRemaining) {
                                            pointsRemaining -=
                                                abilityScoreCost(wisdom.value);
                                            wisdom.value++;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.add,
                                        color: Colors.white))
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        wisdom.value--;
                                        pointsRemaining += 2;
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white)),
                          ],
                        )
                      ]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      " (+${abilityScoreIncreases[4]})",
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 7, 26, 239)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        (wisdom.value + abilityScoreIncreases[4]).toString(),
                        style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 11,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      charisma.name,
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 0, 168, 252)),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 110,
                      width: 116,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(children: [
                        Text(
                          textAlign: TextAlign.center,
                          charisma.value.toString(),
                          style: const TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (8 < charisma.value && charisma.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (charisma.value > 8) {
                                          charisma.value--;
                                          if (charisma.value < 13) {
                                            pointsRemaining++;
                                          } else {
                                            pointsRemaining += 2;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white))
                                : const SizedBox(height: 20, width: 29),
                            (charisma.value < 15)
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          (abilityScoreCost(charisma.value) >
                                                  pointsRemaining)
                                              ? const Color.fromARGB(
                                                  247, 56, 53, 52)
                                              : const Color.fromARGB(
                                                  150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 10, 126, 54)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (charisma.value < 15) {
                                          if (abilityScoreCost(
                                                  charisma.value) <=
                                              pointsRemaining) {
                                            pointsRemaining -= abilityScoreCost(
                                                charisma.value);
                                            charisma.value++;
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.add,
                                        color: Colors.white))
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          150, 61, 33, 243),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      side: const BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromARGB(255, 172, 46, 46)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        charisma.value--;
                                        pointsRemaining += 2;
                                      });
                                    },
                                    child: const Icon(Icons.remove,
                                        color: Colors.white)),
                          ],
                        )
                      ]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      " (+${abilityScoreIncreases[5]})",
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 7, 26, 239)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 7, 26, 239),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        (charisma.value + abilityScoreIncreases[5]).toString(),
                        style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )),
            const Expanded(flex: 13, child: SizedBox()),
          ],
        ),
      ],
    );
  }
}
