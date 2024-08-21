import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/dbModels/DBtable.dart';

class DBVocabulary {
  String italian;
  String german;
  String additional;
  String table_id;
  String id;
  DBVocabulary({required this.italian, required this.german, required this.additional, required this.table_id, required this.id});

  Map<String, dynamic> toJson() => {
    'italian': italian,
    'german': german,
    'additional': additional,
    'table_id': id,
  };

  static DBVocabulary fromJson(QueryDocumentSnapshot<Map<String, dynamic>> doc){
    Map<String, dynamic> json = doc.data();
    return DBVocabulary(
      italian: json['italian'],
      german: json['german'],
      additional: json['additional'],
      table_id: json['table_id'],
      id: doc.id,
    );
  } 

}