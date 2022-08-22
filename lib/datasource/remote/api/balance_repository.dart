import 'package:hashed/datasource/remote/api/http_repo/http_repository.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/utils/result_extension.dart';

class BalanceRepository extends HttpRepository {
  Future<Result<BalanceModel>> getTokenBalance(String address,
      {required String tokenId, required String symbol}) async {
    print('[http] getTokenBalance $address for $symbol');
    final double? res = await polkadotRepository.getBalance(address);
    // [POLKA] need a mapper class for this...
    if (res != null) {
      return Result.value(BalanceModel(res));
    } else {
      return Result.error("Unable to fetch balance");
    }
  }
}
