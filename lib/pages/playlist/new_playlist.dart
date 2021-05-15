import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/pattern/color.dart';

class NewPlaylist extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Stack(clipBehavior: Clip.hardEdge, children: [
        Positioned(
          right: -50,
          top: -50,
          child: InkResponse(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              child: Icon(Icons.close),
              backgroundColor: Colors.red,
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'New playlist',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Theme(
                  data: ThemeData(
                      primaryColor: primaryColor,
                      fontFamily: 'Poppins',
                      textSelectionTheme: TextSelectionThemeData(
                          cursorColor: primaryColor,
                          selectionColor: primaryColor.withOpacity(0.2),
                          selectionHandleColor: primaryColor)),
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Playlist's name",
                      border: UnderlineInputBorder(),
                    ),
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
        )
      ]),
    );
  }
}
