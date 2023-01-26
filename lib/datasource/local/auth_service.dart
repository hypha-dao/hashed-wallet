// ignore_for_file: constant_identifier_names

import 'package:hashed/datasource/local/models/auth_data_model.dart';
import 'package:hashed/utils/mnemonic_code/hex.dart';
import 'package:hashed/utils/mnemonic_code/mnemonic_code.dart';
import 'package:hdkey/hdkey.dart';

const STRENGTH_FOR_TWELVE_WORDS = 16;

class AuthService {
  /// Creates a random private key/12 words pair. Used for user auth.
  AuthDataModel createRandomPrivateKeyAndWords() {
    final words = _createRandom12Words();

    return AuthDataModel(words);
  }

  /// Creates a private key/12 words pair. From words
  AuthDataModel createPrivateKeyFromWords(List<String> words) {
    return AuthDataModel(words);
  }

  AuthDataModel privateKeyFromSeedsGlobalPassportWords(List<String> words) {
    return AuthDataModel(words);
  }

  /// Creates 12 random words Mnemonic.
  List<String> _createRandom12Words() {
    final bytes = randomBytes(STRENGTH_FOR_TWELVE_WORDS);
    return entropyToMnemonic(hexCodec.encode(bytes)).split('-');
  }

  /// Helper method to create an ETH key from a mnemonic
  HDKey generateEthDerivedKeyFromSeed(String mnemonic) {
    final HDKey hdkey = HDKey.fromMnemonic(mnemonic);
    const walletHdpath = "m/44'/60'/0'/0/1";
    final HDKey childKey = hdkey.derive(walletHdpath);
    return childKey;
  }
}
