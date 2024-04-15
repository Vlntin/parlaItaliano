import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/handler/table.dart';

class Tables {
  String title;
  int level;
  String id;
  Tables({required this.title, required this.level, required this.id});

  Map<String, dynamic> toJson() => {
    'title': title,
    'level': level,
  };

  static Tables fromJson(QueryDocumentSnapshot<Map<String, dynamic>> doc){
    Map<String, dynamic> json = doc.data();
    return Tables(
      title: json['title'],
      level: json['level'],
      id: doc.id,
    );
  } 
}