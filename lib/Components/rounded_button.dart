import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RoundedButton extends StatelessWidget {
  String title;
  Function onPressed;
  RoundedButton({this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.all(65.0),
        child: RaisedButton(
          color: Colors.lightBlue,
          elevation: 8,
          onPressed: onPressed,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 8,
              ),
              Icon(
                MdiIcons.google,
                size: 25,
              ),
              SizedBox(
                width: 35,
              ),
              Text(
                title,
                style: TextStyle(color: Colors.black87, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
