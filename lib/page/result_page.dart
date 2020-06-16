import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/dico_elix.dart';
import 'package:zephyr/utils.dart';
import 'package:zephyr/zephyr_localization.dart';

import '../zephyr_theme.dart';

class ResultPage extends StatefulWidget {
  final List<String> keywords;

  ResultPage(this.keywords, {DicoElix dicoElix, List<Sign> signs}) : super();

  @override
  State createState() => new _ResultPageState(this.keywords);
}

class _ResultPageState extends State<ResultPage> {
  List<String> _keywords;
  DicoElix _dicoElix;
  List<Sign> _signs;
  Map<int, VideoPlayerController> _thumbnails = new Map();

  /// Result page state constructor.
  ///
  /// [_keywords] is the list of keywords (it can be one or multiple items separated by whitespaces), and they will be
  /// used then by  [dicoElix] to fetch the [signs] if not provided by the users. The [_keywords] can be accessed
  /// through [keywords] through a getter and a setter, and when new values are given, the [_signs] are refreshed, so
  /// is the list.
  _ResultPageState(List<String> keywords, {DicoElix dicoElix, List<Sign> signs}) : super() {
    if (dicoElix == null) dicoElix = DicoElix();

    _dicoElix = dicoElix;

    if (signs == null)
      this.keywords = keywords;
    else {
      _keywords = keywords;
      _signs = signs;
    }
  }

  @override
  void dispose() {
    for (VideoPlayerController controller in _thumbnails.values) controller.dispose();
    super.dispose();
  }

  /// Play or pause the video depending on its current state.
  ///
  /// If the video was paused, it will play it, and vice-versa, using [controller]. It will update the current state.
  void triggerVideo(VideoPlayerController controller) {
    setState(() {
      if (controller.value.isPlaying)
        controller.pause();
      else
        controller.play();
    });
  }

  //#region PROPERTIES

  /// Get the list of current keywords for the result screen.
  List<String> get keywords => _keywords;

  /// Set the new keywords for the result search.
  ///
  /// It will fetch the new values and display them in the result page.
  set keywords(List<String> values) {
    if (values == null) throw "keywords cannot be null.";
    _keywords = values;
    _dicoElix.getSigns(_keywords).then((value) {
      setState(() {
        print("Fetched ${value.length} sign${plural(value.length)}");
        _signs = value;
        for (Sign sign in _signs) {
          int hash = sign.hashCode;
          _thumbnails[hash] = sign.getVideoPlayerController();
          _thumbnails[hash].initialize().then((value) => setState(() {}));
        }
      });
    });
  }

  /// Join the keywords list with whitespaces.
  String get joinedKeywords => _keywords?.join(' ') ?? '';

  //#endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: ZephyrTheme.getIconThemeData(context),
        title: Text(
          _signs != null
              ? ZephyrLocalization.of(context).resultsFor(_signs.length, joinedKeywords)
              : ZephyrLocalization.of(context).loading(),
          style: TextStyle(color: ZephyrTheme.getFontColor(context)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int idx) {
          // Add a divider
          if (idx.isOdd) return new Divider();
          // Shift indices
          int i = idx ~/ 2;

          // Print the signs
          if (_signs != null) {
            if (i < _signs.length) {
              if (_signs[i].videoUrl == null || !_thumbnails[_signs[i].hashCode].value.initialized) {
                return ListTile(
                  leading: _signs[i].videoUrl == null ? Icon(Icons.videocam_off) : CircularProgressIndicator(),
                  title: Text(_signs[i].word),
                  subtitle: Text(_signs[i].definition),
                );
              } else {
                _thumbnails[_signs[i].hashCode].setLooping(true);
                // the sign has a video URL and the thumbnail is initialized
                return ExpansionTile(
                  leading: AspectRatio(
                    aspectRatio: _thumbnails[_signs[i].hashCode].value.aspectRatio,
                    child: VideoPlayer(_thumbnails[_signs[i].hashCode]),
                  ),
                  title: Text(_signs[i].word),
                  subtitle: Text(_signs[i].definition),
                  trailing: Icon(Icons.keyboard_arrow_down),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_signs[i].word, style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: () => triggerVideo(_thumbnails[_signs[i].hashCode]),
                            child: AspectRatio(
                              aspectRatio: _thumbnails[_signs[i].hashCode].value.aspectRatio,
                              child: VideoPlayer(_thumbnails[_signs[i].hashCode]),
                            ),
                          ),
                          IconButton(
                            icon: Icon(_thumbnails[_signs[i].hashCode].value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled),
                            onPressed: () => triggerVideo(_thumbnails[_signs[i].hashCode]),
                          ),
                          Text(_signs[i].definition),
                        ],
                      ),
                    ),
                  ],
                );
              }
            } else
              return null;
          } else {
            if (i == 0)
              return ListTile(
                leading: CircularProgressIndicator(),
                title: Text(ZephyrLocalization.of(context).loading()),
              );
            else
              return null;
          }
        },
      ),
    );
  }
}
