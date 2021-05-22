import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music_player/pattern/color.dart';
import 'package:music_player/controller/local_file.dart';

class DownloadPage extends StatefulWidget {
  final String uri;

  const DownloadPage({Key key, this.uri}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  bool downloading = false;
  double progress = 0;
  bool isDownloaded = false;
  String filename;

  Future<void> downloadFile(uri) async {
    setState(() {
      downloading = true;
    });

    String savePath = await getFilePath(filename);
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
    String dir = await getDownloadPath();
    path = '${dir}/$uniqueFileName';
    // print(path);
    return path;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!isDownloaded) {
      filename = widget.uri.substring(widget.uri.lastIndexOf("/") + 1);
      downloadFile(widget.uri);
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
            isDownloaded ? Text('Download ${filename} completed') : Text("Downloading"),
          ],
        )
      ]),
    );
  }
}
