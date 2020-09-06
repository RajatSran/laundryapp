import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPage extends StatelessWidget {
  final String email;
  final Firestore _firestore = Firestore.instance;
  HistoryPage(this.email);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.1),
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
        centerTitle: true,
        title: Text(
          'History',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('receivedandsend').snapshots(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final history = snapshot.data.documents;
                List<Widget> wid = [];
                for (var his in history) {
                  if (his.data['email'] == email) {
                    String type;
                    if (his.data['type'] == 'student') {
                      type = 'Received by student';
                    } else {
                      type = 'Submitted to laundry';
                    }
                    final String when = his.data['when'];
                    final String name = his.data['name'];
                    final hiswidget = Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          width: double.infinity,
                          height: 75,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Color(0XFFFAACA8),
                                    Color(0xFFDDD6F3)
                                  ],
                                  stops: [
                                    0.2,
                                    0.8
                                  ]),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text('Name: ' + name),
                              Text(type),
                              Text('on ' + when),
                            ],
                          ),
                        ));
                    wid.add(hiswidget);
                  }
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: wid,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
