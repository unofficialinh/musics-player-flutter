import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../color.dart';

class SeekBar extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const SeekBar(this.audioPlayer, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: StreamBuilder(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final processingState = snapshot.data?.processingState;

              if (processingState != ProcessingState.ready) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.07,
                      child: Text(
                        '0:00',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 3,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 5),
                      ),
                      child: Container(
                        width: size.width * 0.75,
                        child: Slider(
                          value: 0,
                          min: 0,
                          max: 10,
                          activeColor: primaryColor,
                          inactiveColor: primaryColor.withOpacity(0.3),
                          onChanged: null,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.07,
                      child: Text(
                        '0:00',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              } else
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder(
                        stream: audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          return Container(
                            width: size.width * 0.07,
                            child: Text(
                              audioPlayer.position.inMinutes.toString() +
                                  ':' +
                                  (audioPlayer.position.inSeconds % 60)
                                      .toString()
                                      .padLeft(2, '0'),
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                    StreamBuilder(
                        stream: audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          return SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 3,
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 5),
                            ),
                            child: Container(
                              width: size.width * 0.75,
                              child: Slider(
                                  value: audioPlayer.position.inMilliseconds
                                      .toDouble(),
                                  min: 0,
                                  max: audioPlayer.duration.inMilliseconds
                                      .toDouble(),
                                  activeColor: primaryColor,
                                  inactiveColor: primaryColor.withOpacity(0.3),
                                  onChanged: (value) {
                                    audioPlayer.seek(
                                        Duration(milliseconds: value.toInt()));
                                  }),
                            ),
                          );
                        }),
                    StreamBuilder(
                        stream: audioPlayer.durationStream,
                        builder: (context, snapshot) {
                          return Container(
                            width: size.width * 0.07,
                            child: Text(
                              audioPlayer.duration.inMinutes.toString() +
                                  ':' +
                                  (audioPlayer.duration.inSeconds % 60)
                                      .toString()
                                      .padLeft(2, '0'),
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                  ],
                );
            }));
  }
}
