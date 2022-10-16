import 'loading.dart';
import 'package:flutter/material.dart';
import 'package:protect/login.dart';
import 'package:protect/signup.dart';
import 'package:protect/userdb_helper.dart';
import 'database_helper.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Loading(),
  ));
}
