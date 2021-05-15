import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/pattern/bottom_navigation.dart';
import 'package:music_player/pattern/color.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isConnected = true;

  Future<void> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
      }
    } on SocketException catch (err) {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      toolbarHeight: 80,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Center(
        child: Text(
          'EDIT PROFILE',
          style: TextStyle(color: Colors.grey, fontSize: 22),
        ),
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            onPressed: null)
      ],
    );
  }

  Widget getBody() {
    if (!isConnected) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 80,
            ),
            Text(
              'No internet',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Theme(
              data: ThemeData(
                  primaryColor: primaryColor,
                  fontFamily: 'Poppins',
                  textSelectionTheme: TextSelectionThemeData(
                      cursorColor: primaryColor,
                      selectionColor: primaryColor.withOpacity(0.2),
                      selectionHandleColor: primaryColor)),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(fontSize: 20),
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        fillColor: primaryColor.withOpacity(0.1),
                        filled: true,
                        labelText: "Name",
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    style: TextStyle(fontSize: 20),
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        fillColor: primaryColor.withOpacity(0.1),
                        filled: true,
                        labelText: "Email",
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    style: TextStyle(fontSize: 20),
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        fillColor: primaryColor.withOpacity(0.1),
                        filled: true,
                        labelText: "Age",
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 10, horizontal: 25)),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
              child: Text(
                "SAVE",
                style: TextStyle(fontSize: 22),
              ),
              onPressed: () {
                // if (_formKey.currentState.validate()) {
                //   _formKey.currentState.save();
                // }
                Navigator.pop(context);
                final snackBar = SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    "Created new playlist!",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //TODO: create a new playlist
              },
            ),
          )
        ],
      ),
    );
  }
}
