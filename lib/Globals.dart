import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

late CollectionReference exercises;
late SharedPreferences prefs;

late String dataSource;
