import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wally_app/widget_tree.dart';
import 'dart:async';

var db = FirebaseFirestore.instance.collection("Users");

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyDdfb23B4CSkam7U9DTa36tBiUjI8umdOE',
              appId: '1:666482531240:android:cc411ad4f2167b6e139b9d',
              messagingSenderId: '666482531240',
              projectId: 'composite-helix-414916'))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
    );
  }
}
