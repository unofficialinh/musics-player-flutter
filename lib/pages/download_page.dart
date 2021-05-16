import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music_player/pattern/color.dart';
import 'package:path_provider/path_provider.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  bool downloading = false;
  double progress = 0;
  bool isDownloaded = false;
  String uri = 'http://3.141.168.131:5000/mp3/glitter.mp3';
  String filename = 'test';

  Future<void> downloadFile(uri, fileName) async {
    setState(() {
      downloading = true;
    });

    String savePath = await getFilePath(fileName);
    Dio dio = Dio();

    dio.download(
      uri,
      savePath,
      onReceiveProgress: (rcv, total) {
        print(
            'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
        setState(() {
          progress = rcv / total;
        });
        if (progress == 1) {
          setState(() {
            isDownloaded = true;
          });
        } else if (progress < 1) {}
      },
      deleteOnError: true,
    ).then((_) {
      setState(() {
        if (progress == 1) {
          isDownloaded = true;
        }
        downloading = false;
      });
    });
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/$uniqueFileName.jpg';
    print(path);
    return path;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!isDownloaded) {
      downloadFile(uri, filename);
    }
  }

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
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(),
            SizedBox(
              height: 15,
            ),
            !isDownloaded
                ? SizedBox(
                    height: 65,
                    width: 65,
                    child: CircularProgressIndicator(
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      strokeWidth: 8,
                    ),
                  )
                : Icon(
                    Icons.check_circle_outline_rounded,
                    color: primaryColor,
                    size: 85,
                  ),
            SizedBox(
              height: 25,
            ),
            isDownloaded ? Text('Download completed') : Text("Downloading"),
          ],
        )
      ]),
    );
  }
}
