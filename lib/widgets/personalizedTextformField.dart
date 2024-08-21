import 'package:flutter/material.dart';

class PersonalizedTextformField extends TextFormField{

  String hintText = '';
  TextEditingController controller;
  String? Function(String?)? newValidator;

  PersonalizedTextformField({required this.controller, this.newValidator, required this.hintText, super.key}): super(
    cursorColor: Colors.black,
    decoration: const InputDecoration(
      hintText: 'Passwort',
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
    validator: newValidator,  
  );
}