import 'package:flutter/material.dart';

Widget beveledButton(
  {
    required String title, 
  required GestureTapCallback onTap}
){
  return ElevatedButton(
    onPressed: onTap, 
    style: ElevatedButton.styleFrom(
      backgroundColor:  Colors.blue,
      foregroundColor: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      )
    ),
    child: Text(title,style: const TextStyle(fontFamily: "Gothic"),)
    );
}