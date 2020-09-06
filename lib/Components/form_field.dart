import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final String title;
  TextInputType typ;
  IconData IcDa;
  FormWidget({this.title, this.typ = null, this.IcDa = null});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: typ,
      decoration: InputDecoration(
        icon: Icon(IcDa),
        labelText: title,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'is required';
        }

        return null;
      },
    );
  }
}
