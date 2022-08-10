import 'package:async/async.dart';
import 'package:hashed/datasource/remote/api/http_repo/http_repository.dart';
import 'package:hashed/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:hashed/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:hashed/datasource/remote/model/seeds_history_model.dart';
import 'package:http/http.dart' as http;

///Seeds History Table
class SeedsHistoryRepository extends HttpRepository {
  Future<Result<SeedsHistoryModel>> getNumberOfTransactions(String userAccount) {
    print('[http] get seeds seeds history for account: $userAccount ');

    final String request = createRequest(
      code: SeedsCode.historySeeds,
      scope: SeedsCode.historySeeds.value,
      table: SeedsTable.tableTotals,
      lowerBound: userAccount,
      upperBound: userAccount,
    );

    final seedsHistoryURL = Uri.parse('$hyphaURL/v1/chain/get_table_rows');

    return http
        .post(seedsHistoryURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<SeedsHistoryModel>(response, (dynamic body) {
              return SeedsHistoryModel.fromJson(body);
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }
}
