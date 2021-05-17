import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/pattern/color.dart';
import 'package:music_player/pages/root_app.dart';
import 'package:music_player/pattern/snackbar.dart';

const users = const {
  'linhnt149@gmail.com': '12345',
  'longnn13@gmail.com': '12345',
};

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _login(LoginData data) {
    return login(data.name, data.password).then((value) {
      if (!users.containsKey(data.name) || users[data.name] != data.password) {
        return 'Username or password is incorrect!';
      }
      return null;
    });
  }

  Future<String> _register(LoginData data) {
    return register(data.name, data.password).then((value) {
      if (value != null) {
        return value;
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
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

      // loginProviders: <LoginProvider>[
      //   LoginProvider(
      //     icon: FontAwesomeIcons.google,
      //     callback: () async {
      //       print('start google sign in');
      //       await Future.delayed(loginTime);
      //       print('stop google sign in');
      //       return null;
      //     },
      //   ),
      //   LoginProvider(
      //     icon: FontAwesomeIcons.facebookF,
      //     callback: () async {
      //       print('start facebook sign in');
      //       await Future.delayed(loginTime);
      //       print('stop facebook sign in');
      //       return null;
      //     },
      //   ),
      //   LoginProvider(
      //     icon: FontAwesomeIcons.linkedinIn,
      //     callback: () async {
      //       print('start linkdin sign in');
      //       await Future.delayed(loginTime);
      //       print('stop linkdin sign in');
      //       return null;
      //     },
      //   ),
      //   LoginProvider(
      //     icon: FontAwesomeIcons.githubAlt,
      //     callback: () async {
      //       print('start github sign in');
      //       await Future.delayed(loginTime);
      //       print('stop github sign in');
      //       return null;
      //     },
      //   ),
      // ],

      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => RootApp(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
