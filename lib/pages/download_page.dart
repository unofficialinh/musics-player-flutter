import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/pattern/color.dart';
import 'package:music_player/controller/local_file.dart';

class DownloadPage extends StatefulWidget {
  final dynamic song;

  const DownloadPage({Key key, this.song}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  bool downloading = false;
  double progress = 0;
  bool isDownloaded = false;
  String filename;
  Future<bool> existed;

  Future<void> downloadFile(uri, bool imgDownloaded, bool mp3Downloaded) async {
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
        if (progress == 1 && imgDownloaded && mp3Downloaded) {
          setState(() {
            isDownloaded = true;
          });
        } else if (progress < 1) {}
      },
      deleteOnError: true,
    ).then((_) {
      setState(() {
        if (progress == 1 && imgDownloaded && mp3Downloaded) {
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
    return path;
  }

  @override
  void initState() {
    super.initState();
    existed = addDownloadedSong(widget.song).then((value) {
      if (value) {
        String mp3 = widget.song['mp3'];
        String img = widget.song['img'];
        if (!isDownloaded) {
          filename = img.substring(img.lastIndexOf("/") + 1);
          downloadFile(img, true, false).then((value) {
            filename = mp3.substring(mp3.lastIndexOf("/") + 1);
            downloadFile(mp3, true, true);
          });
        }
      }
      return !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: existed,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var value = snapshot.data;
            if (value) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                content: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(),
                        SizedBox(
                          height: 15,
                        ),
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: primaryColor,
                          size: 85,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          child: Text(
                            '"${widget.song['title']}" was downloaded before.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                content: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      primaryColor),
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
                        isDownloaded
                            ? Container(
                              child: Text(
                                  'Download "${widget.song['title']}" completed!',
                                  textAlign: TextAlign.center,
                                ),
                            )
                            : Text("Downloading"),
                      ],
                    )
                  ],
                ),
              );
          }
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ));
        });
  }
}
