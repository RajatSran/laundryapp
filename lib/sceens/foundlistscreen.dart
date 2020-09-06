import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './additemscreen.dart';
import '../products.dart';
import 'product_detail_screen.dart';

class FoundListScreen extends StatefulWidget {
  @override
  _FoundListScreenState createState() => _FoundListScreenState();
}

class _FoundListScreenState extends State<FoundListScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchandsetproducts().then((_) {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 19,
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0),
        centerTitle: true,
        title: Text(
          'Lost and Found',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddScreen.routeName);
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Products>(
              child: Center(
                child: Text('no lost items to show'),
              ),
              builder: (ctx, products, ch) => products.items.length <= 0
                  ? ch
                  : ListView.builder(
                      itemCount: products.items.length,
                      itemBuilder: (_, i) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(products.items[i].imageurl),
                        ),
                        title: Text(
                          products.items[i].title,
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                        onTap: () async {
                          print(await products.items[i]);
                          String im = products.items[i].imageurl.toString();
                          String tit = products.items[i].title.toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      im, tit, products.items[i].description)));
                        },
                      ),
                    ),
            ),
    );
  }
}
