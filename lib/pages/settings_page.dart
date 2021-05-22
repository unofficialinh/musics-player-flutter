import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/authentication/login_page.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/pages/settings/change_password.dart';
import 'package:music_player/pages/settings/edit_profile.dart';
import 'package:music_player/pattern/color.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pattern/bottom_navigation.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
      bottomNavigationBar: BottomNavigation(
        activeTab: 3,
      ),
    );
  }

  Widget getAppBar() {
    return AppBar(
      toolbarHeight: 100,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 10, top: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  child: Icon(
                    Icons.account_circle,
                    color: primaryColor,
                    size: 40,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: size.width * 0.7,
                  child: Text(
                    "Account",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Divider(
              indent: 5,
              endIndent: 5,
              thickness: 1,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: EditProfile(),
                        type: PageTransitionType.rightToLeft));
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontSize: 22, color: Colors.black.withOpacity(0.7)),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: ChangePassword(),
                        type: PageTransitionType.rightToLeft));
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Change Password",
                      style: TextStyle(
                          fontSize: 22, color: Colors.black.withOpacity(0.7)),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                //TODO: logout
                logout().then((value) async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove('token');
                });
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: LoginPage(), type: PageTransitionType.rotate));
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 22, color: Colors.black.withOpacity(0.7)),
                    ),
                    Icon(Icons.logout)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  child: Icon(
                    Icons.notifications_active_rounded,
                    color: primaryColor,
                    size: 35,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: size.width * 0.7,
                  child: Text(
                    "Notification",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Divider(
              indent: 5,
              endIndent: 5,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "App Notification",
                    style: TextStyle(
                        fontSize: 22, color: Colors.black.withOpacity(0.7)),
                  ),
                  Switch(
                    value: true,
                    activeColor: primaryColor,
                    onChanged: (value) {},
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email & SMS",
                    style: TextStyle(
                        fontSize: 22, color: Colors.black.withOpacity(0.7)),
                  ),
                  Switch(
                    value: false,
                    activeColor: primaryColor,
                    onChanged: (value) {},
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  child: Icon(
                    Icons.dashboard_rounded,
                    color: primaryColor,
                    size: 35,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: size.width * 0.7,
                  child: Text(
                    "More",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Divider(
              indent: 5,
              endIndent: 5,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Language",
                    style: TextStyle(
                        fontSize: 22, color: Colors.black.withOpacity(0.7)),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Country",
                    style: TextStyle(
                        fontSize: 22, color: Colors.black.withOpacity(0.7)),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
