import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

late CollectionReference exercises;
late SharedPreferences prefs;

late String dataSource;

const Color blue = Color(0xff1e90ff);
const Color grey = Color(0xff5F5F5F);