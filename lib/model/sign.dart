import 'package:video_player/video_player.dart';

class Sign {
  String word = '';
  String videoUrl = null;
  String definition = '';

  Sign(this.word, this.videoUrl, {this.definition});

  /// Create a [Sign] from the given [json].
  factory Sign.fromJson(Map<String, dynamic> json) {
    return Sign(
      json['word'] as String,
      json['videoUrl'] as String,
      definition: json['definition'] as String,
    );
  }

  /// Convert this instance into a JSON object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'word': word,
      'videoUrl': videoUrl,
      'definition': definition,
    };
  }

  VideoPlayerController getVideoPlayerController() {
    return new VideoPlayerController.network(videoUrl);
  }

  Future<VideoPlayerController> getVideoPlayerControllerInitialized() async {
    VideoPlayerController controller = getVideoPlayerController();
    await controller.initialize();
    return Future.value(controller);
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
