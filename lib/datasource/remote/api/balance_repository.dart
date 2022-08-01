import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';

class BalanceRepository extends HttpRepository {
  Future<Result<BalanceModel>> getTokenBalance(String userAccount, {required String tokenId, required String symbol}) {
    print('[http] get seeds getTokenBalance $userAccount for $symbol');
    // [POLKA] get balance

    throw UnimplementedError();

    // final String request = '''
    // {
    //   "code":"$tokenId",
    //   "account":"$userAccount",
    //   "symbol":"$symbol"
    // }
    // ''';

    // final balanceURL = Uri.parse('$baseURL/v1/chain/get_currency_balance');

    // return http
    //     .post(balanceURL, headers: headers, body: request)
    //     .then((http.Response response) => mapHttpResponse<BalanceModel>(response, (dynamic body) {
    //           return BalanceModel.fromJson(body);
    //         }))
    //     .catchError((dynamic error) => mapHttpError(error));
  }
}
