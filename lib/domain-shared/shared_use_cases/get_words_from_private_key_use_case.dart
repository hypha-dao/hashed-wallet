class GetWordsFromPrivateKey {
  /// If the private key has words, it returns the list of words
  /// otherwise an empty list.
  /// Handles both passport and seeds light wallet style 12 words keys
  List<String> run() {
    // final String privateKey = settingsStorage.privateKey!;

    // final wordsString = settingsStorage.recoveryWords.firstWhere((item) {
    //   final words = item.toWordList();
    //   return GenerateKeyFromRecoveryWordsUseCase().run(words).eOSPrivateKey.toString() == privateKey ||
    //       GenerateKeyFromSeedsPassportWordsUseCase().run(words).eOSPrivateKey.toString() == privateKey;
    // }, orElse: () => '');

    // return wordsString.isNotEmpty ? wordsString.toWordList() : [];
    return []; // TODO(n13): remove
  }
}

extension WordListString on String {
  List<String> toWordList() {
    return split('-');
  }
}
