import 'package:chat_app/navigation/navigation_service.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/service_locators.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocators();
  runApp(const MyApp());
}
