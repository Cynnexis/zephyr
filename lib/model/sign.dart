import 'package:video_player/video_player.dart';

class Sign {
  String word;
  String videoUrl;
  String definition;

  Sign(this.word, this.videoUrl, {this.definition});

  VideoPlayerController getVideoPlayerController() {
    return new VideoPlayerController.network(videoUrl);
  }

  @override
  String toString() {
    return 'Sign{word: $word, videoUrl: $videoUrl, definition: $definition}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sign &&
          runtimeType == other.runtimeType &&
          word == other.word &&
          videoUrl == other.videoUrl &&
          definition == other.definition;

  @override
  int get hashCode => word.hashCode ^ videoUrl.hashCode ^ definition.hashCode;
}
