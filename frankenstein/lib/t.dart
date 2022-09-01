import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';

Future<void> readJson() async {
  final String response = await rootBundle.loadString('SRDspells.json');
  final data = await json.decode(response);
  final users = data['users'];
  print(users);
}
