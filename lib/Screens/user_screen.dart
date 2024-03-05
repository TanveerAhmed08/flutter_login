// ignore_for_file: must_be_immutable

// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/Widget/beveled_button.dart';
import 'package:flutter_login/Widget/body_back.dart';
import 'package:flutter_login/services/user_dao.dart';

import '../modals/user.dart';

// ignore: camel_case_types
class userScreen extends StatefulWidget {
 userScreen({required this.displayName ,super.key});
  String displayName;
  UserDao users = UserDao();

  @override
  State<userScreen> createState() => _userScreenState();
}

// ignore: camel_case_types
class _userScreenState extends State<userScreen> {
  final Future <FirebaseApp> _future = Firebase.initializeApp();
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool  editStatus = false;
  String? key;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('${widget.displayName}',style: TextStyle(color: Colors.white),)),
      ),
       backgroundColor: Colors.blue,
      body: BackGroundContainer(
        // ignore: avoid_unnecessary_containers
        Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: fillBody(),
          ),
        )
      ),
       floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _scrollToBottom,
        child:  Icon(Icons.move_down,color: Colors.blue[50],),
      ),
    );
  }

  Widget fillBody(){
    return SafeArea(
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshots){
           if(snapshots.hasError){
            return Text(snapshots.error.toString());
           }
           else{
            return Column(
              children:<Widget> [
                const SizedBox(height: 10.0,),
                Padding(padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: "Enter Your Name",
                    hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))
                  ),
                )
                ),
                const SizedBox(height: 10.0,),
                  Padding(padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: "Your Comment",
                    hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))
                  ),
                )
                ),
                const SizedBox(height: 10.0,),
                beveledButton( onTap: (){
                  _saveData(_nameController.text, _commentController.text);
               
                }, title: 'Save'),
                const SizedBox(height: 10.0,),
                _getMessageList()
              ],
            );
           }
        }
      )
      );
  }

  Widget _getMessageList(){
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: widget.users.getMessageQuery(), 
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final users = Users.fromJson(json);
          return Card(
            child: ListTile(
              title: Text(users.name),
              subtitle: Text(users.comment),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){
                    key =  snapshot.key;
                    _nameController.text  =  users.name;
                    _commentController.text  =  users.comment;
                    editStatus = true;
                  }, icon: const Icon(Icons.edit)),
                  IconButton(onPressed: (){
                    key = snapshot.key;
                    _deleteData(key!);
                  }, icon: const Icon(Icons.delete)),
                ]),
            ),
          );
        },
        )
        );
  }

  void _scrollToBottom(){
   if (_scrollController.hasClients) {
     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
   }
  }
  void clearData(){
    _nameController.clear();
    _commentController.clear();
  }

  void _saveData(String name,String comment){
  final user = Users(name,comment);

 

  switch(editStatus){
    case false:
      widget.users.SaveUsers(user);
      clearData();
    break;
    case true:
    editStatus = false;
    widget.users.updateUser(key!, user);
    clearData();
    break;
  }
  }
  
   void _deleteData(String key){
    widget.users.deleteUser(key);
    clearData();
  }
}
