// ignore: unused_import
import 'package:flutter/material.dart';


String? validateEmail(String? value) {
      Pattern pattern = r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$';
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value.toString())) {
        return "Enter valid email";
      } else {
        return null;
      }
    }

String? validatePass(String? value){
  Pattern pattern = r'\d{8}$';
  RegExp regex = RegExp(pattern.toString());
  if (!regex.hasMatch(value.toString())) {
    return 'only 8 char. digit XXXXXXXX required';
  }else{
    return null;
  }
}