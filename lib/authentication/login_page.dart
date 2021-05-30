import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/pattern/color.dart';
import 'package:music_player/pages/root_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 0);

  Future<String> _login(LoginData data) {
    return login(data.name, data.password).then((response) async {
      final prefs = await SharedPreferences.getInstance();
      if (response["token"] != null) {
        prefs.setString('token', response["token"]);
        return null;
      }
      else {
        return response["result"];
      }
    });
  }

  Future<String> _register(LoginData data) {
    return register(data.name, data.password).then((response) {
      if (response.statusCode == HttpStatus.badRequest) {
        return json.decode(response.body)["errors"].toString();
      }
      else if (response.statusCode != HttpStatus.created) {
        return json.decode(response.body)["result"];
      }

      // get token
      login(data.name, data.password).then((response) async {
        final prefs = await SharedPreferences.getInstance();
        if (response["token"] != null) {
          prefs.setString('token', response["token"]);
        }
      });
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return null;
    // Nothing here, not implement yet ok?
    // print('Name: $name');
    // return Future.delayed(loginTime).then((_) {
    //   if (!users.containsKey(name)) {
    //     return 'Username not exists';
    //   }
    //   return null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _login,
      onSignup: _register,

      theme: LoginTheme(
        primaryColor: primaryColor,
        accentColor: primaryColor,
        errorColor: primaryColor,
        pageColorLight: Colors.deepPurpleAccent.shade100,
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: primaryColor.withOpacity(.1),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(30)),
        ),
        textFieldStyle: TextStyle(fontSize: 16),
        bodyStyle: TextStyle(fontSize: 16),
        buttonStyle: TextStyle(fontSize: 16),
        authButtonPadding: EdgeInsets.only(top: 10),
      ),

      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => RootApp(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
