import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:zephyr/model/favorites.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/preferences.dart';
import 'package:zephyr/zephyr_localization.dart';

class SignListPage extends StatefulWidget {
  final List<Sign> signs;

  SignListPage({Key key, @required this.signs}) : super(key: key) {
    if (signs == null) throw "signs cannot be null";
  }

  @override
  _SignListPageState createState() => _SignListPageState();
}

class _SignListPageState extends State<SignListPage> {
  Map<Sign, Future<VideoPlayerController>> futureControllers = Map();
  Set<VideoPlayerController> controllers = Set();

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
  Widget build(BuildContext context) {
    // If no signs, show a text
    if (widget.signs == null || widget.signs.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Icon(Icons.search, size: 100),
          ),
          SizedBox(height: 32.0),
          Text(
            ZephyrLocalization.of(context).noSigns(),
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      );
    }

    // Initialize the list that will contains the future video player controllers, for all given signs
    for (Sign sign in widget.signs)
      if (!futureControllers.containsKey(sign) || futureControllers[sign] == null)
        futureControllers[sign] = sign.getVideoPlayerControllerInitialized();

    return ListView.builder(
      key: Key("signs_list"),
      itemBuilder: (BuildContext context, int idx) {
        if (0 <= idx && idx <= 1) return new Container(height: 35);

        // Shift indices
        int i = (idx ~/ 2) - 1;
        if (i >= widget.signs.length) return null;

        // Add a divider
        if (idx.isOdd) return new Divider();

        // Print the signs
        if (widget.signs[i].videoUrl == null) {
          return ListTile(
            leading: Icon(Icons.videocam_off),
            title: Text(widget.signs[i].word),
            subtitle: Text(widget.signs[i].definition),
          );
        } else {
          // Wait for the video (thumbnail and controller)
          return FutureBuilder(
            key: Key("future_result_$i"),
            future: futureControllers[widget.signs[i]],
            builder: (context, snapshot) {
              VideoPlayerController controller = snapshot.data;

              Widget title = Row(
                children: <Widget>[
                  Text(widget.signs[i].word),
                  Consumer<Favorites>(
                    builder: (context, favorites, _) {
                      if (favorites.contains(widget.signs[i])) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.favorite,
                            size: 16.0,
                          ),
                        );
                      } else
                        return Container();
                    },
                  ),
                ],
              );

              Widget subtitle = Text(widget.signs[i].definition);

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
                  title: title,
                  subtitle: subtitle,
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
                                widget.signs[i].word,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                              ),
                              Consumer<Favorites>(
                                builder: (context, favorites, _) => IconButton(
                                  key: Key("sign_result_favorite_$i"),
                                  icon: Icon(
                                      favorites.contains(widget.signs[i]) ? Icons.favorite : Icons.favorite_border),
                                  tooltip: favorites.contains(widget.signs[i])
                                      ? ZephyrLocalization.of(context).removeFromFavorites()
                                      : ZephyrLocalization.of(context).addToFavorites(),
                                  onPressed: () {
                                    // Trigger favorites
                                    if (favorites.contains(widget.signs[i]))
                                      favorites.remove(widget.signs[i]);
                                    else
                                      favorites.add(widget.signs[i]);

                                    // Save favorites
                                    saveFavorites(favorites);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Tooltip(
                            message: ZephyrLocalization.of(context).triggerVideoExplanation(),
                            child: GestureDetector(
                              onTap: () => triggerVideo(controller),
                              child: AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: VideoPlayer(controller),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          subtitle,
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // If the thumbnail and the video are still loading, display a simple tile with a progress bar
                return ListTile(
                  leading: CircularProgressIndicator(),
                  title: title,
                  subtitle: subtitle,
                );
              }
            },
          );
        }
      },
    );
  }
}
