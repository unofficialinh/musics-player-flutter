import 'dart:io';

import 'package:flutter/material.dart';
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
        ));
  }

  Widget getBody() {
    _checkInternetConnection();
    if (!isConnected) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80,),
            Text('No internet', style: TextStyle(fontSize: 20),),
          ],
        ),
      );
    }

    return Center(child: Text('Chưa dev xong :)'));
  }
}
