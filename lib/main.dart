import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'dashboard_counter.dart';
import 'package:flutter/material.dart';
import 'products.dart';
import 'package:provider/provider.dart';
import './sceens/foundlistscreen.dart';
import './sceens/additemscreen.dart';
import './sceens/product_detail_screen.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Products(),
      child: MaterialApp(
        home: welcome_screen(),
        routes: {
          AddScreen.routeName: (ctx) => AddScreen(),
        },
      ),
    );
  }
}
