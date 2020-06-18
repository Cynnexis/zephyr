import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/dico_elix.dart';
import 'package:zephyr/utils.dart';
import 'package:zephyr/zephyr_localization.dart';

class ResultPage extends StatefulWidget {
  final String keywords;

  ResultPage(this.keywords) : super();

  @override
  State createState() => new _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  DicoElix _dicoElix;
  Set<VideoPlayerController> controllers = {};

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
    if (widget.keywords == null) throw "keywords cannot be null.";
  }

  void dispose() {
    for (VideoPlayerController controller in controllers) controller.dispose();
    controllers.clear();
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
  FutureBuilder build(BuildContext context) {
    // Wait for the signs
    return FutureBuilder(
      future: _dicoElix.getSigns([widget.keywords]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Sign> signs = snapshot.data;

          // If no results were returned
          if (signs.isEmpty) {
            return Center(
              child: Text(
                "No results",
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          }

          return ListView.builder(
            itemBuilder: (BuildContext context, int idx) {
              // Add a divider
              if (idx.isOdd) return new Divider();
              // Shift indices
              int i = idx ~/ 2;

              // Print the signs
              if (i < signs.length) {
                if (signs[i].videoUrl == null) {
                  return ListTile(
                    leading: Icon(Icons.videocam_off),
                    title: Text(signs[i].word),
                    subtitle: Text(signs[i].definition),
                  );
                } else {
                  signs[i].getVideoPlayerController().setLooping(true);
                  // Wait for the video (thumbnail and controller)
                  return FutureBuilder(
                    future: signs[i].getVideoPlayerControllerInitialized(),
                    builder: (context, snapshot) {
                      VideoPlayerController controller = snapshot.data;
                      controllers.add(controller);

                      // If the video is fetched, display the thumbnail and put the video in the expanded part
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ExpansionTile(
                          leading: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                          title: Text(signs[i].word),
                          subtitle: Text(signs[i].definition),
                          trailing: Icon(Icons.keyboard_arrow_down),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(signs[i].word, style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 16.0),
                                  GestureDetector(
                                    onTap: () => triggerVideo(controller),
                                    child: AspectRatio(
                                      aspectRatio: controller.value.aspectRatio,
                                      child: VideoPlayer(controller),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                    ),
                                    onPressed: () => triggerVideo(controller),
                                  ),
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
          return ListTile(
            leading: CircularProgressIndicator(),
            title: Text(ZephyrLocalization.of(context).loading()),
          );
        }
      },
    );
  }
}
