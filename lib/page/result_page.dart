import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/dico_elix.dart';
import 'package:zephyr/utils.dart';

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
      appBar: AppBar(
        title: Text("Result${plural(_signs?.length ?? 0)} for \"$joinedKeywords\""),
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
              return ListTile(
                leading: // If the sign has no video URL, print an icon instead
                    _signs[i].videoUrl == null
                        ? Container(
                            width: 90.0,
                            height: 56.0,
                            child: Icon(Icons.videocam_off),
                          )
                        : // If the thumbnail is ready, show it, otherwise show a progress bar
                        (_thumbnails[_signs[i].hashCode].value.initialized
                            ? Container(
                                width: 90.0,
                                height: 56.0,
                                child: VideoPlayer(_thumbnails[_signs[i].hashCode]),
                              )
                            : CircularProgressIndicator()),
                title: Text(_signs[i].word),
                subtitle: Text(_signs[i].definition),
                trailing: _signs[i].videoUrl != null ? Icon(Icons.keyboard_arrow_right) : null,
              );
            } else
              return null;
          } else {
            if (i == 0)
              return ListTile(
                leading: CircularProgressIndicator(),
                title: Text("Loading..."),
              );
            else
              return null;
          }
        },
      ),
    );
  }
}
