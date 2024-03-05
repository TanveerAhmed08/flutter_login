// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_login/modals/user.dart';

class UserDao{
  final _databaseRef = FirebaseDatabase.instance.ref('comments');

  // ignore: non_constant_identifier_names
  void SaveUsers(Users user){
    _databaseRef.push().set(user.toJson());
  }

  void updateUser(String key, Users users){
    _databaseRef.child(key).update(users.toMap());
  }
  void deleteUser(String key){
    _databaseRef.child(key).remove();
  }

  Query getMessageQuery(){
    if(!kIsWeb){
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }
    return _databaseRef;
  }
}