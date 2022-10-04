import 'package:async/async.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';

class StopGuardianRecoveryUseCase {
  Future<List<Result>> run(List<ActiveRecoveryModel>? recoveries, {bool mock = false}) async {
    final address = accountService.currentAccount.address;

    final List<Result> results = [];

    if (recoveries == null) {
      print("no recoveries");
      return [];
    }

    if (mock) {
      print("Mock mode - returning success");
      for (final _ in recoveries) {
        results.add(Result.value("Ok"));
      }
      return Future.delayed(const Duration(milliseconds: 1000), () => results);
    }

    for (final recovery in recoveries) {
      if (recovery.lostAccount == address) {
        print("removing recovery ${recovery.lostAccount} ${recovery.rescuer}");

        final res = await polkadotRepository.recoveryRepository.closeRecovery(
          lostAccount: address,
          rescuer: recovery.rescuer,
        );

        results.add(res);
      }
    }

    return results;
  }
}
