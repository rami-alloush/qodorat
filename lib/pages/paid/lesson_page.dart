import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:qodorattest/models.dart';

class LessonPage extends StatefulWidget {
  LessonPage(this.lesson);

  final Lesson lesson;

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  YoutubePlayerController _controller = YoutubePlayerController();
  bool _muted = false;
  String _videoId;

//  var _idController = TextEditingController();
//  var _seekToController = TextEditingController();
//  double _volume = 100;

//  void listener() {
//    if (_controller.value.playerState == PlayerState.ENDED) {
//      _controller.seekTo(
//        Duration(seconds: 0),
//      );
//      _showThankYouDialog();
//    }
////    setState(() {
////      _playerStatus = _controller.value.playerState.toString();
////      _errorCode = _controller.value.errorCode.toString();
////      print(_controller.value.toString());
////    });
//  }

  @override
  void deactivate() {
    // This pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _videoId = YoutubePlayer.convertUrlToId(widget.lesson.videoURL);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lesson.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            YoutubePlayer(
              context: context,
              videoId: _videoId,
              mute: false,
              autoPlay: true,
//              hideControls: true,
              forceHideAnnotation: true,
              showVideoProgressIndicator: true,
              videoProgressIndicatorColor: Colors.amber,
//              actions: <Widget>[
//                IconButton(
//                  icon: Icon(
//                    Icons.arrow_back_ios,
//                    color: Colors.white,
//                    size: 14.0,
//                  ),
//                  onPressed: () {},
//                ),
//                Text(
//                  widget.lesson.title,
//                  style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 16.0,
//                    fontWeight: FontWeight.w200,
//                  ),
//                ),
//                Spacer(),
//                IconButton(
//                  icon: Icon(
//                    Icons.settings,
//                    color: Colors.white,
//                    size: 18.0,
//                  ),
//                  onPressed: () {},
//                ),
//              ],
              progressColors: ProgressColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
              onPlayerInitialized: (controller) {
                _controller = controller;
//                _controller.addListener(listener);
              },
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.play_arrow
                                    : Icons.pause,
                              ),
                              onPressed: () {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                  _muted ? Icons.volume_off : Icons.volume_up),
                              onPressed: () {
                                _muted
                                    ? _controller.unMute()
                                    : _controller.mute();
                                setState(() {
                                  _muted = !_muted;
                                });
                              },
                            ),
                            IconButton(
                                icon: Icon(Icons.fullscreen),
                                onPressed: () => _controller.enterFullScreen()),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text("${widget.lesson.exploratoryText1}"),
                              Divider(),
                              Text("${widget.lesson.exploratoryText2}"),
                            ],
                          ),
                        ),
//                  Padding(
//                    padding: EdgeInsets.all(8.0),
//                    child: Text(
//                      "Status: $_playerStatus",
//                      style: TextStyle(
//                        fontWeight: FontWeight.w300,
//                      ),
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.all(8.0),
//                    child: Text(
//                      "Error Code: $_errorCode",
//                      style: TextStyle(
//                        fontWeight: FontWeight.w300,
//                      ),
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
