import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';

class KeyValidationResult {
  String? publicKey;
  String? errorMessage;
  bool get isError => errorMessage != null;
  KeyValidationResult({this.publicKey, this.errorMessage});
}

class CheckPrivateKeyUseCase {
  Future<KeyValidationResult> isKeyValid(String privateKey) async {
    final List<String> words = privateKey.trim().split(" ");
    if (words.length != 12) {
      return KeyValidationResult(
          errorMessage:
              "Secret phrase should have 12 words but this only has ${words.length}. \n\nMake sure words are separated by spaces like this:\norange food spice india ...");
    }
    try {
      final publicKey = await polkadotRepository.publicKeyForPrivateKey(privateKey);
      //print("publicKey: $publicKey");
      return KeyValidationResult(publicKey: publicKey);
    } catch (e, s) {
      print("Error unable to parse key $privateKey");
      print("Error: $e");
      print(s);
      return KeyValidationResult(errorMessage: "Unable to parse key $privateKey");
    }
  }
}
