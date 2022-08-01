import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:seeds/utils/result_extension.dart';

class BalanceRepository extends HttpRepository {
  Future<Result<BalanceModel>> getTokenBalance(String address,
      {required String tokenId, required String symbol}) async {
    print('[http] get seeds getTokenBalance $address for $symbol');
    final double res = await polkadotRepository.getBalance(address);
    // [POLKA] need a mapper class for this...
    return Result(() => BalanceModel(res));
  }
}
