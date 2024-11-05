import 'package:cloud_firestore/cloud_firestore.dart';

class DBTables {
  String title;
  int level;
  String id;
  DBTables({required this.title, required this.level, required this.id});

  Map<String, dynamic> toJson() => {
    'title': title,
    'level': level,
  };

  static DBTables fromJson(QueryDocumentSnapshot<Map<String, dynamic>> doc){
    Map<String, dynamic> json = doc.data();
    return DBTables(
      title: json['title'],
      level: json['level'],
      id: doc.id,
    );
  } 
}