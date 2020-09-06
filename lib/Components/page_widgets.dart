import 'package:flutter/material.dart';

class PageViewWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onPressed;
  PageViewWidget(this.icon, this.title, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onPressed,
          child: CircleAvatar(
            child: Icon(
              icon,
              size: 35,
              color: Color(0xff1a181b),
            ),
            radius: 35,
            backgroundColor: Color(0xff7EA0B7),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          title,
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
