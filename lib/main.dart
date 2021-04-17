import 'package:flutter/material.dart';
import 'package:music_player/pages/root_app.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Poppins'),
    debugShowCheckedModeBanner: false,
    home: RootApp(),
  ));
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:music_player/color.dart';
// import 'package:music_player/model/myaudio.dart';
// import 'package:music_player/playerControls.dart';
// import 'package:provider/provider.dart';
//
// import 'albumart.dart';
// import 'navbar.dart';
//
// Map audio = {
//   'image':
//       'https://thegrowingdeveloper.org/thumbs/1000x1000r/audios/quiet-time-photo.jpg',
//   'url':
//       'https://thegrowingdeveloper.org/files/audios/quiet-time.mp3?b4869097e4'
// };
//
// void main() {
//   runApp(MaterialApp(
//     theme: ThemeData(fontFamily: 'Loew'),
//     debugShowCheckedModeBanner: false,
//     home: ChangeNotifierProvider(create: (_) => MyAudio(), child: HomePage()),
//   ));
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   double sliderValue = 2;
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           NavigationBar(),
//           Container(
//             height: height / 2.5,
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 return AlbumArt();
//               },
//               itemCount: 3,
//               scrollDirection: Axis.horizontal,
//             ),
//           ),
//           Text(
//             'Name',
//             style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//                 color: darkPrimaryColor),
//           ),
//           Text(
//             'Hehe boiz',
//             style: TextStyle(fontSize: 25, color: darkPrimaryColor),
//           ),
//           SliderTheme(
//               data: SliderThemeData(
//                 trackHeight: 5,
//                 thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
//               ),
//               child: Consumer<MyAudio>(
//                 builder: (_, myAudioModel, child) => Slider(
//                   value: myAudioModel.position == null
//                       ? 0
//                       : myAudioModel.position.inMilliseconds.toDouble(),
//                   activeColor: darkPrimaryColor,
//                   inactiveColor: darkPrimaryColor.withOpacity(0.5),
//                   onChanged: (value) {
//                     setState(() {
//                       myAudioModel
//                           .seekAudio(Duration(milliseconds: value.toInt()));
//                     });
//                   },
//                   min: 0,
//                   max: myAudioModel.totalDuration == null
//                       ? 20
//                       : myAudioModel.totalDuration.inMilliseconds.toDouble(),
//                 ),
//               )),
//           PlayerControls(),
//           SizedBox(
//             height: 50,
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ChangeNotifierProvider(create: (_) => MyAudio(), child: HomePage()),
//     );
//   }
// }

