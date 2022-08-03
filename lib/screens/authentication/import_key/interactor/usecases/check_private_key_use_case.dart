import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';

class CheckPrivateKeyUseCase {
  Future<String?> isKeyValid(String privateKey) async {
    try {
      final publicKey = await polkadotRepository.publicKeyForPrivateKey(privateKey);
      return publicKey;
    } catch (e, s) {
      print("Error unable to parse key $privateKey");
      print("Error: $e");
      print(s);
      return null;
    }
  }
}
