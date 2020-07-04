import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:zephyr/model/keywords.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/dico_elix.dart';
import 'package:zephyr/service/preferences.dart';
import 'package:zephyr/zephyr_localization.dart';

class ResultPage extends StatefulWidget {
  final Keywords keywords;

  ResultPage({Key key, this.keywords}) : super(key: key);

  @override
  State createState() => new _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  DicoElix _dicoElix = null;
  Future<List<Sign>> futureSigns = null;
  List<Future<VideoPlayerController>> futureControllers = null;
  Set<VideoPlayerController> controllers = Set();
  Set<Sign> favorites = Set();

  /// Result page state constructor.
  ///
  /// [keywords] is the list of keywords (it can be one or multiple items separated by whitespaces), and they will be
  /// used then by  [dicoElix] to fetch the [signs] if not provided by the users.
  _ResultPageState() : super() {
    _dicoElix = DicoElix();
  }

  @override
  void initState() {
    super.initState();
    loadFavorites().then((value) => setState(() => favorites = value)).catchError((error) {
      if (kDebugMode) {
        print("error: " + (error?.toString() ?? "null"));
        final SnackBar snack = SnackBar(content: Text("An error occurred when loading the favorites."));
        Scaffold.of(context).showSnackBar(snack);
      }
    });
  }

  void dispose() {
    for (VideoPlayerController controller in controllers) controller.dispose();
    controllers.clear();
    favorites.clear();
    super.dispose();
  }

  /// Play or pause the video depending on its current state.
  ///
  /// If the video was paused, it will play it, and vice-versa, using [controller]. It will update the current state.
  void triggerVideo(VideoPlayerController controller) {
    if (controller.value.isPlaying)
      controller.pause();
    else
      controller.play();
  }

  @override
  Widget build(BuildContext context) {
    // Wait for the signs
    if (widget.keywords == null) throw "keywords cannot be null.";

    futureSigns = _dicoElix.getSigns(widget.keywords);
    futureSigns.then((value) {
      futureControllers = List(value.length);
      for (int i = 0; i < value.length; i++) futureControllers[i] = value[i].getVideoPlayerControllerInitialized();
    });

    return FutureBuilder(
      future: futureSigns,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Sign> signs = snapshot.data;

          // If no results were returned
          if (signs == null || signs.isEmpty) {
            return Center(
              child: Text(
                "No results",
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          }

          return ListView.builder(
            key: Key("results_list"),
            itemBuilder: (BuildContext context, int idx) {
              if (0 <= idx && idx <= 1) return new Container(height: 35);

              // Add a divider
              if (idx.isOdd) return new Divider();
              // Shift indices
              int i = (idx ~/ 2) - 1;

              // Print the signs
              if (i < signs.length) {
                if (signs[i].videoUrl == null) {
                  return ListTile(
                    leading: Icon(Icons.videocam_off),
                    title: Text(signs[i].word),
                    subtitle: Text(signs[i].definition),
                  );
                } else {
                  // Wait for the video (thumbnail and controller)
                  return FutureBuilder(
                    key: Key("future_result_$i"),
                    future: futureControllers[i],
                    builder: (context, snapshot) {
                      VideoPlayerController controller = snapshot.data;

                      // If the video is fetched, display the thumbnail and put the video in the expanded part
                      if (snapshot.connectionState == ConnectionState.done) {
                        controllers.add(controller);
                        controller.setLooping(true);
                        return ExpansionTile(
                          key: Key("sign_result_$i"),
                          leading: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                          title: favorites.contains(signs[i])
                              ? Row(
                                  children: <Widget>[
                                    Text(signs[i].word),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Icon(
                                      Icons.favorite,
                                      size: 16.0,
                                    ),
                                  ],
                                )
                              : Text(signs[i].word),
                          subtitle: Text(signs[i].definition),
                          trailing: Icon(Icons.keyboard_arrow_down),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        signs[i].word,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                                      ),
                                      IconButton(
                                        icon:
                                            Icon(favorites.contains(signs[i]) ? Icons.favorite : Icons.favorite_border),
                                        onPressed: () {
                                          // Trigger favorites
                                          if (favorites.contains(signs[i]))
                                            setState(() => favorites.remove(signs[i]));
                                          else
                                            setState(() => favorites.add(signs[i]));
                                          saveFavorites(favorites, append: false);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  GestureDetector(
                                    onTap: () => triggerVideo(controller),
                                    child: AspectRatio(
                                      aspectRatio: controller.value.aspectRatio,
                                      child: VideoPlayer(controller),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(signs[i].definition),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        // If the thumbnail and the video are still loading, display a simple tile with a progress bar
                        return ListTile(
                          leading: CircularProgressIndicator(),
                          title: Text(signs[i].word),
                          subtitle: Text(signs[i].definition),
                        );
                      }
                    },
                  );
                }
              } else
                // If the end of the list has been reached
                return null;
            },
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(key: Key("loading_signs_results")),
                SizedBox(height: 32),
                Text(ZephyrLocalization.of(context).loading()),
              ],
            ),
          );
        }
      },
    );
  }
}
