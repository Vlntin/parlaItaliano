import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parla_italiano/handler/table.dart';

class VocabularyWidget extends StatelessWidget {
  const VocabularyWidget(this.italian, this.german, this.additional, {super.key});

  final String additional;
  final String italian;
  final String german;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text (italian),
              flex: 3),
            const SizedBox(width: 8),
            Expanded(
              child: Text (german),
              flex: 3),
            const SizedBox(width: 8),
            Expanded(
              child: Text (additional),
              flex: 3),],
        ));
  }
}

