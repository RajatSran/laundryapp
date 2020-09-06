import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:laundryproject/sceens/foundlistscreen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'Components/page_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'history.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:wiredash/wiredash.dart';

class dashboard extends StatefulWidget {
  String name;
  String email;
  String photoUrl;
  dashboard(this.name, this.email, this.photoUrl);
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  bool isCollapsed = true;
  final Duration duration = Duration(milliseconds: 350);
  double screenheight;
  double screenwidth;
  String barres;
  String _now = DateTime.now().toString();
  final Firestore _firestore = Firestore.instance;
  List<String> forqr;
  Timer _timer;

  void _time() {
    Future.delayed(Duration(seconds: 30)).then((_) {
      setState(() {
        _now = DateTime.now().toString();
        // Anything else you want
      });
      _time();
    });
  }

  Future scanBarcode() async {
    try {
      var barresult = await BarcodeScanner.scan();
      barres = barresult.rawContent.toString();
      print(barres);
      forqr = barres.split(',');
      print(forqr);
      if (forqr[0] == 'NU_CHECK' && forqr[1] == 'LaundryData') {
        _firestore.collection('send').add(
            {'when': forqr[2], 'name': widget.name, 'email': widget.email});
        _firestore.collection('receivedandsend').add({
          'when': forqr[2],
          'name': widget.name,
          'email': widget.email,
          'type': 'student'
        });

        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              "Marked",
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
                "Unable to register on server. If this happens repeatedly contact the laundry counter to get this step done manually."),
          ),
        );
      }
    } on PlatformException catch (e) {
      if (e.code == "BarcodeScanner.CameraAccessDenied") {
        print('shit');
      }
    } on FormatException catch (e) {
      print('You pressed back button');
    } catch (e) {
      print('Unknown error');
    }
  }

  @override
  Widget build(BuildContext context) {
    _time();
    Size size = MediaQuery.of(context).size;
    screenheight = size.height;
    screenwidth = size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[menu(context), dashb(context)],
        ),
      ),
    );
  }

  Widget dashb(context) {
    return AnimatedPositioned(
      duration: duration,
      top: isCollapsed ? 0 : 0.2 * screenheight,
      bottom: isCollapsed ? 0 : 0.2 * screenwidth,
      left: isCollapsed ? 0 : 0.6 * screenwidth,
      right: isCollapsed ? 0 : -0.4 * screenwidth,
      child: SingleChildScrollView(
        child: SizedBox(
          height: 730,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              color: Color(0xff1A181B),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: InkWell(
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                              onTap: () {
                                setState(() {
                                  isCollapsed = !isCollapsed;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: InkWell(
                              onTap: () {
                                Wiredash.of(context).show();
                              },
                              child: Icon(
                                Icons.report,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Laundry ',
                            style: TextStyle(
                                fontSize: 32,
                                color: Color(0xffd81e5b),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'app',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xffeeeeee),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Welcome ',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: 16),
                          ),
                          Text(
                            '${widget.name.toUpperCase()}',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color(0xffd81e5b),
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      isCollapsed
                          ? Expanded(
                              child: Container(
                                width: isCollapsed ? null : double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0xffF9F4F5),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(75))),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0, left: 50, right: 50),
                                      child: QrImage(
                                        size: isCollapsed ? null : 0,
                                        data: 'NU_CHECK,' +
                                            'Student,' +
                                            widget.name +
                                            ',' +
                                            widget.email +
                                            ',' +
                                            _now,
                                        foregroundColor: Color(0xff000000),
                                      ),
                                    ),
                                    Text(
                                      'Get this code scanned at the laundry counter',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: isCollapsed ? null : 0,
                                          color: Color(0xff725ac1),
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 25.0),
                                        child: PageView(
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  PageViewWidget(
                                                      Icons.camera_alt,
                                                      "Scan",
                                                      scanBarcode),
                                                  PageViewWidget(
                                                      Icons.report_problem,
                                                      "Lost and Found", () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FoundListScreen()));
                                                  }),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  PageViewWidget(
                                                      Icons.history, "History",
                                                      () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                HistoryPage(widget
                                                                    .email)));
                                                  })
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget menu(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 21.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image(
              image: NetworkImage(
                widget.photoUrl,
              ),
            ),
            Text(widget.name,
                style: TextStyle(fontSize: 17, fontFamily: 'Montserrat')),
            Text(
              widget.email,
              style: TextStyle(fontSize: 10, fontFamily: 'Montserrat'),
            ),
            SizedBox(
              height: 80,
            ),
            InkWell(
              child: Text(
                'Dashboard',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
                onTap: scanBarcode,
                child: Text('Scan QR', style: TextStyle(fontSize: 20))),
            SizedBox(
              height: 15,
            ),
            Text('Rate List', style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 15,
            ),
            Text('Report a bug', style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.power_settings_new,
                    color: Colors.black54,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
