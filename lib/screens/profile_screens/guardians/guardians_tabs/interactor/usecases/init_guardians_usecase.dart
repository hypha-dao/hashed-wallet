import 'package:seeds/datasource/local/flutter_js/polkawallet_init.dart';
import 'package:seeds/datasource/local/models/account.dart';
import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';

class ActivateGuardiansUseCase {
  Future<void> initGuardians(Iterable<Account> myGuardians) async {
    await polkadotRepository.initGuardians(myGuardians.map((e) => e.address).toList());
  }
}
