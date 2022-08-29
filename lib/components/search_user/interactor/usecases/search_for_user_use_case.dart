import 'package:async/async.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';

class SearchForMemberUseCase {
  Future<Result<Account?>> run(String address) {
    return polkadotRepository.getIdentity(address);
  }
}
