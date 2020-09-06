import 'package:flutter/material.dart';
import 'package:laundryproject/products.dart';
import 'package:provider/provider.dart';

import '../lostproduct.dart';

class DetailScreen extends StatelessWidget {
  String title;
  String image;
  String description;
  DetailScreen(this.image, this.title, this.description);
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
