import 'package:flutter/material.dart';
import 'package:laundryproject/dashboard.dart';
import 'Components/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'Components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:laundryproject/laundry_login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class welcome_screen extends StatefulWidget {
  @override
  _welcome_screenState createState() => _welcome_screenState();
}

class _welcome_screenState extends State<welcome_screen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser _user;
  bool spinner = false;

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _authentication =
        await _googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _authentication.idToken,
        accessToken: _authentication.accessToken);
    _user = (await _firebaseAuth.signInWithCredential(credential)).user;
    print('User name: ${_user.displayName}');
    return _user;
  }

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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onLongPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LaundryLoginPage()));
                  },
                  child: Container(
                    height: 120,
                    child: TypewriterAnimatedTextKit(
                      text: ['Spin and Dry\nLaundry'],
                      textStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 42,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: RoundedButton(
                    title: 'Login with Google',
                    onPressed: () async {
                      setState(() {
                        spinner = true;
                      });
                      try {
                        await _signIn();
                        if (_user.email.split('@')[1] ==
                            'st.niituniversity.in') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => dashboard(
                                      _user.displayName,
                                      _user.email,
                                      _user.photoUrl)));
                          setState(() {
                            spinner = false;
                          });
                        } else {
                          setState(() async {
                            await _googleSignIn.signOut();
                            spinner = false;
                          });
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(
                                        'Use st.niituniversity.in id only'),
                                  ));
                        }
                      } catch (e) {
                        setState(() {
                          spinner = false;
                        });
                        print(e);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
