import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/color.dart';
import 'package:page_transition/page_transition.dart';

import 'playing_list_page.dart';

class ControlButtons extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const ControlButtons(this.audioPlayer, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              iconSize: 25,
              icon: Icon(
                Icons.replay_30_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                if (audioPlayer.position.inSeconds.toInt() > 30)
                  audioPlayer.seek(Duration(
                      seconds: audioPlayer.position.inSeconds.toInt() - 30));
                else
                  audioPlayer.seek(Duration.zero);
              },
            ),
            StreamBuilder<SequenceState>(
              stream: audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return previousButton();
              },
            ),
            StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (_, snapshot) {
                final playerState = snapshot.data;
                return playPauseButton(playerState);
              },
            ),
            StreamBuilder<SequenceState>(
              stream: audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return nextButton();
              },
            ),
            IconButton(
              iconSize: 25,
              icon: Icon(
                Icons.forward_30_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                if (audioPlayer.position.inSeconds.toInt() + 30 <
                    audioPlayer.duration.inSeconds.toInt())
                  audioPlayer.seek(Duration(
                      seconds: audioPlayer.position.inSeconds.toInt() + 30));
                else
                  audioPlayer.seek(audioPlayer.duration);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  iconSize: 25,
                  icon: Icon(
                    Icons.favorite,
                    color: primaryColor,
                  ),
                  onPressed: null),
              StreamBuilder<bool>(
                stream: audioPlayer.shuffleModeEnabledStream,
                builder: (context, snapshot) {
                  return shuffleButton(context, snapshot.data ?? false);
                },
              ),
              StreamBuilder<LoopMode>(
                stream: audioPlayer.loopModeStream,
                builder: (context, snapshot) {
                  return repeatButton(context, snapshot.data ?? LoopMode.off);
                },
              ),
              IconButton(
                  iconSize: 25,
                  icon: Icon(
                    Icons.queue_music,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          alignment: Alignment.bottomCenter,
                          child: PlayingList(),
                          type: PageTransitionType.rightToLeft,
                        ));
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget shuffleButton(BuildContext context, bool isEnable) {
    return IconButton(
        icon: Icon(
          Icons.shuffle,
          color: isEnable ? primaryColor : Colors.grey,
        ),
        onPressed: () async {
          final enable = !isEnable;
          if (enable) {
            await audioPlayer.shuffle();
          }
          await audioPlayer.setShuffleModeEnabled(enable);
        });
  }

  Widget previousButton() {
    return IconButton(
        iconSize: 40,
        icon: Icon(Icons.skip_previous_rounded),
        onPressed: audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null);
  }

  Widget playPauseButton(PlayerState playerState) {
    final processingState = playerState?.processingState;

    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return IconButton(
          iconSize: 80,
          icon: Icon(
            Icons.circle,
            color: primaryColor,
          ),
          onPressed: null);
    } else if (audioPlayer.playing != true) {
      return IconButton(
          iconSize: 80,
          icon: Icon(
            Icons.play_circle_fill_rounded,
            color: primaryColor,
          ),
          onPressed: audioPlayer.play);
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
          iconSize: 80,
          icon: Icon(
            Icons.pause_circle_filled,
            color: primaryColor,
          ),
          onPressed: audioPlayer.pause);
    } else {
      return IconButton(
        iconSize: 80,
        icon: Icon(
          Icons.play_circle_fill_rounded,
          color: primaryColor,
        ),
        onPressed: () => audioPlayer.seek(Duration.zero,
            index: audioPlayer.effectiveIndices.first),
      );
    }
  }

  Widget nextButton() {
    return IconButton(
        iconSize: 40,
        icon: Icon(Icons.skip_next_rounded),
        onPressed: audioPlayer.hasNext ? audioPlayer.seekToNext : null);
  }

  Widget repeatButton(BuildContext context, LoopMode loopMode) {
    final icons = [
      Icon(
        Icons.repeat_rounded,
        color: Colors.grey,
      ),
      Icon(Icons.repeat_rounded, color: primaryColor),
      Icon(Icons.repeat_one_rounded, color: primaryColor),
    ];
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);

    return IconButton(
        icon: icons[index],
        onPressed: () {
          audioPlayer.setLoopMode(cycleModes[
              (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
        });
  }
}
