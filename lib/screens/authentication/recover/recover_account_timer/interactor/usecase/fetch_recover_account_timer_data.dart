// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class FetchRecoverAccountTimerDataUseCase {
  Future<Result<DateTime>> run(ActiveRecoveryModel model, GuardiansConfigModel configModel) async {
    final lastBlock = await polkadotRepository.getLastBlockNumber();

    if (lastBlock.isError) {
      print("failed to retrieve last block ${lastBlock.asError!.error}");
      return Result.error(lastBlock.asError!.error);
    }

    print("==>  last block ${lastBlock.asValue!.value}");
    final blockCreated = model.created;

    print("==>  created ${blockCreated}");

    final recoveryDelayInBlocks = configModel.delayPeriod;
    print("==>  delay ${recoveryDelayInBlocks}");

    final unlockBlock = blockCreated + recoveryDelayInBlocks;

    final blocksRemaining = unlockBlock - lastBlock.asValue!.value;

    print("==>  blocksRemaining ${blocksRemaining}");

    final blockTimeSeconds = polkadotRepository.getBlockTimeSeconds();

    final secondsRemaining = blocksRemaining * blockTimeSeconds;

    print("==>  secondsRemaining ${secondsRemaining}");

    return Result.value(DateTime.now().add(Duration(seconds: secondsRemaining)));
  }
}
