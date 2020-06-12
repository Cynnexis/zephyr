class Sign {
  String word;
  String videoUrl;
  String definition;

  Sign(this.word, this.videoUrl, [this.definition]);

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
