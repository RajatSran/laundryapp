import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'dashboard_counter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LaundryLoginPage extends StatefulWidget {
  @override
  _LaundryLoginPageState createState() => _LaundryLoginPageState();
}

class _LaundryLoginPageState extends State<LaundryLoginPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _email;

  String _pass;

  bool spinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0XFFFAACA8), Color(0xFFDDD6F3)],
                  stops: [0.2, 0.8]),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Text(
                      'Laundry Login',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Text(
                  'This page is supposed to be for login of the Laundry Counter. Will not work for student login.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                TextFieldLaundryPage('Username', (value) {
                  _email = value;
                }, false, TextInputType.emailAddress),
                TextFieldLaundryPage('Password', (value) {
                  _pass = value;
                }, true, TextInputType.visiblePassword),
                RaisedButton(
                  onPressed: () async {
                    setState(() {
                      spinner = true;
                    });
                    try {
                      final _user =
                          await _firebaseAuth.signInWithEmailAndPassword(
                              email: _email, password: _pass);
                      print('no' + _user.toString());
                      if (_user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => dashboard()));

                        setState(() {
                          spinner = false;
                        });
                      }
                    } catch (e) {
                      setState(() {
                        spinner = false;
                      });
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            "Email/password is wrong. Also, check your internet connection",
                            style: TextStyle(fontFamily: 'Montserrat'),
                          ),
                        ),
                      );
                    }
                  },
                  color: Color(0xFFDDD6F3).withOpacity(0.7),
                  elevation: 8,
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldLaundryPage extends StatelessWidget {
  final String title;
  final Function onchange;
  final bool obs;
  final TextInputType ty;
  TextFieldLaundryPage(this.title, this.onchange, this.obs, this.ty);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        obscureText: obs,
        keyboardType: ty,
        onChanged: onchange,
        decoration: InputDecoration(
            focusColor: Colors.white,
            labelText: title,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}
