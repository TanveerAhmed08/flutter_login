import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
BackGroundContainer(child){
  return Container(
    decoration: const BoxDecoration(
      color: Color.fromARGB(255, 255, 255, 255),
      // image: DecorationImage(
      //   image: const AssetImage('assets/images/background.jpg'),
      //   fit: BoxFit.fill,
      //   colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.9), BlendMode.dstATop)
      // ),
    ),
    child: child,
  );
}