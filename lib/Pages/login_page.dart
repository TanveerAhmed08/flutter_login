import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/Screens/user_screen.dart';
import 'package:flutter_login/Widget/beveled_button.dart';
import 'package:flutter_login/Widget/body_back.dart';
import 'package:flutter_login/services/auth_service.dart';
import 'package:flutter_login/services/frm_validation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late bool _obscured;
  final togglePassowrdFocusNode = FocusNode();
  bool _isProcessing = false;

  String? email;
  String? pass;

  final _dialogkey = GlobalKey<FormState>();
  String? displayName;

  @override
  void initState() {
    super.initState();
    _obscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.w900),
            // style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: BackGroundContainer(
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 150, 20, 0),
          child: fillBody(),
        ),
      ),
    );
  }

  Widget fillBody() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "User Email",
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: validateEmail,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              obscureText: _obscured,
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "User Password",
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: _toggleObscured,
                      child: Icon(
                        _obscured
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  )),
              validator: validatePass,
              onSaved: (value) {
                setState(() {
                  pass = value;
                });
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            _isProcessing
                ? const SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: Center(child: CircularProgressIndicator()))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(top: 10),
                          width: 150,
                          child: beveledButton(

                              onTap: onLoginSubmit, title: 'Login',)),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                          width: 150,
                          child:
                              beveledButton(onTap: () {}, title: 'Register')),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (togglePassowrdFocusNode.hasPrimaryFocus) {
        return;
      }
      togglePassowrdFocusNode.canRequestFocus = false;
    });
  }

  void onLoginSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      // ScaffoldMessenger.of(context)
      // .showSnackBar(const SnackBar(content: Text('Login in....')));
      setState(() {
        _isProcessing = true;
      });
      await Future.delayed(const Duration(seconds: 2), () {});
      _signInUser();
      setState(() {
        _isProcessing = false;
      });
      await Future.delayed(const Duration(seconds: 2), () {});
      // ignore: non_constant_identifier_names
      String? u_name;
      // ignore: unused_local_variable
      bool? emailVerification;
      // ignore: unused_local_variable
      String? email;

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        u_name = user.displayName;
        emailVerification = user.emailVerified;
        // email = user.email;
      }
      // ScaffoldMessenger.of(context)
      // .showSnackBar(SnackBar(content: Text("Welcome, ${email.toString()}")));
      if (u_name == null) {
        await _updateNameDialog();
        await Future.delayed(const Duration(seconds: 2), () {});
        String sname = displayName.toString();
        await Future.delayed(const Duration(seconds: 2), () {});
        await user?.updateDisplayName(sname.toUpperCase());
      }
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  userScreen(displayName: u_name.toString())));
    }
  }

  void _signInUser() {
    AuthenticateHelpler()
        .signIn(email: email.toString(), password: pass.toString())
        .then((value) {
      if (value == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Succesfull login')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value)));
      }
    });
  }

  Future<void> _updateNameDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[350],
            title: const Text('Add Username'),
            content: Form(
              key: _dialogkey,
              child: TextFormField(
                style: Theme.of(context).textTheme.titleMedium,
                decoration: const InputDecoration(
                    hintText: "Enter Your name",
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.perm_identity)),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "please Enter Your Name";
                  }
                  return null;
                },
                onSaved: (value) {
                  displayName = value;
                },
              ),
            ),
            actions: <Widget>[
              beveledButton(
                  title: "Cancel",
                  onTap: () {
                    _dialogkey.currentState!.save();
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget));
                  }),
              beveledButton(
                  title: "Rigester Name",
                  onTap: () {
                    if (_dialogkey.currentState!.validate()) {
                      _dialogkey.currentState!.save();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => super.widget));
                    }
                  }),
            ],
          );
        });
  }
}
