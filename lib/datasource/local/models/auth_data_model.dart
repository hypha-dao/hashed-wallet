class AuthDataModel {
  final List<String> words;
  String get wordsString => words.join(" ");

  AuthDataModel(this.words);

  factory AuthDataModel.fromString(String words) {
    return AuthDataModel(words.split(" "));
  }
}
