import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/pattern/bottom_navigation.dart';
import 'package:music_player/pattern/color.dart';
import 'package:music_player/pattern/snackbar.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _old;
  String _new;
  String _confirm;
  bool obscureNew = true;
  bool obscureOld = true;
  bool obscureConfirm = true;
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
          'CHANGE PASSWORD',
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

    return SingleChildScrollView(
      child: Form(
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
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your old password';
                        }
                        return null;
                      },
                      obscureText: obscureOld,
                      style: TextStyle(fontSize: 20),
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        filled: true,
                        fillColor: primaryColor.withOpacity(0.1),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye_rounded),
                          onPressed: () {
                            setState(() {
                              obscureOld = !obscureOld;
                            });
                          },
                        ),
                        labelText: "Old Password",
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none),
                      ),
                      onChanged: (value) => _old = value,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password';
                        }
                        if (value.length < 8) {
                          return 'Password too short';
                        }
                        return null;
                      },
                      obscureText: obscureNew,
                      style: TextStyle(fontSize: 20),
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        filled: true,
                        fillColor: primaryColor.withOpacity(0.1),
                        labelText: "New Password",
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye_rounded),
                          onPressed: () {
                            setState(() {
                              obscureNew = !obscureNew;
                            });
                          },
                        ),
                      ),
                      onChanged: (value) => _new = value,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your confirm password';
                        }
                        if (value != _new) {
                          return "Password doesn't match";
                        }
                        return null;
                      },
                      obscureText: obscureConfirm,
                      style: TextStyle(fontSize: 20),
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        filled: true,
                        fillColor: primaryColor.withOpacity(0.1),
                        labelText: "Confirm Password",
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye_rounded),
                          onPressed: () {
                            setState(() {
                              obscureConfirm = !obscureConfirm;
                            });
                          },
                        ),
                      ),
                      onChanged: (value) => _confirm = value,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
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
                  if (_formKey.currentState.validate()) {
                    updateUserPassword(_old, _new, _confirm).then((value) {
                      snackBar(context, value);
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
