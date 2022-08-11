import 'package:hashed/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:hashed/domain-shared/shared_use_cases/get_words_from_private_key_use_case.dart';

class ShouldShowRecoveryPhraseFeatureUseCase {
  bool shouldShowRecoveryPhrase() =>
      remoteConfigurations.featureFlagExportRecoveryPhraseEnabled && GetWordsFromPrivateKey().run().isNotEmpty;
}
