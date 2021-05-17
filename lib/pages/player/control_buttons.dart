import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/pattern/color.dart';
import 'package:page_transition/page_transition.dart';

import 'playing_list_page.dart';

class ControlButtons extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final dynamic song_id;

  const ControlButtons(this.audioPlayer, {Key key, this.song_id})
      : super(key: key);

  @override
  _ControlButtonsState createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  bool isFav = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (widget.audioPlayer.position.inSeconds.toInt() > 30)
                  widget.audioPlayer.seek(Duration(
                      seconds:
                          widget.audioPlayer.position.inSeconds.toInt() - 30));
                else
                  widget.audioPlayer.seek(Duration.zero);
              },
            ),
            StreamBuilder<SequenceState>(
              stream: widget.audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return previousButton();
              },
            ),
            StreamBuilder<PlayerState>(
              stream: widget.audioPlayer.playerStateStream,
              builder: (_, snapshot) {
                final playerState = snapshot.data;
                return playPauseButton(playerState);
              },
            ),
            StreamBuilder<SequenceState>(
              stream: widget.audioPlayer.sequenceStateStream,
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
                if (widget.audioPlayer.position.inSeconds.toInt() + 30 <
                    widget.audioPlayer.duration.inSeconds.toInt())
                  widget.audioPlayer.seek(Duration(
                      seconds:
                          widget.audioPlayer.position.inSeconds.toInt() + 30));
                else
                  widget.audioPlayer.seek(widget.audioPlayer.duration);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: isFavorite(widget.song_id),
                builder: (context, snapshot) {
                  return favoriteButton(context, snapshot.data);
                },
              ),
              StreamBuilder<bool>(
                stream: widget.audioPlayer.shuffleModeEnabledStream,
                builder: (context, snapshot) {
                  return shuffleButton(context, snapshot.data ?? false);
                },
              ),
              StreamBuilder<LoopMode>(
                stream: widget.audioPlayer.loopModeStream,
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
            await widget.audioPlayer.shuffle();
          }
          await widget.audioPlayer.setShuffleModeEnabled(enable);
        });
  }

  Widget previousButton() {
    return IconButton(
        iconSize: 40,
        icon: Icon(Icons.skip_previous_rounded),
        onPressed: widget.audioPlayer.hasPrevious
            ? widget.audioPlayer.seekToPrevious
            : null);
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
    } else if (widget.audioPlayer.playing != true) {
      return IconButton(
          iconSize: 80,
          icon: Icon(
            Icons.play_circle_fill_rounded,
            color: primaryColor,
          ),
          onPressed: widget.audioPlayer.play);
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
          iconSize: 80,
          icon: Icon(
            Icons.pause_circle_filled,
            color: primaryColor,
          ),
          onPressed: widget.audioPlayer.pause);
    } else {
      widget.audioPlayer.seek(Duration.zero,
          index: widget.audioPlayer.effectiveIndices.first);
      widget.audioPlayer.pause();
      return IconButton(
        iconSize: 80,
        icon: Icon(
          Icons.play_circle_fill_rounded,
          color: primaryColor,
        ),
        onPressed: () => widget.audioPlayer.play,
      );
    }
  }

  Widget nextButton() {
    return IconButton(
        iconSize: 40,
        icon: Icon(Icons.skip_next_rounded),
        onPressed:
            widget.audioPlayer.hasNext ? widget.audioPlayer.seekToNext : null);
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
          widget.audioPlayer.setLoopMode(cycleModes[
              (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
        });
  }

  Widget favoriteButton(BuildContext context, isFavorite ) {
    //TODO: change to future variable
    if (isFav) {
      return IconButton(
        iconSize: 25,
        icon: Icon(
          Icons.favorite,
          color: primaryColor,
        ),
        onPressed: () {
          deleteSongFromFavorite(widget.song_id).then((value) {
            final snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                value,
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
          setState(() {isFav = !isFav;});
        },
      );
    } else
      return IconButton(
        iconSize: 25,
        icon: Icon(
          Icons.favorite_border,
          color: primaryColor,
        ),
        onPressed: () {
          addSongToFavorite(widget.song_id).then((value) {
            final snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                value,
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
          setState(() {isFav = !isFav;});
        },
      );
  }
}
