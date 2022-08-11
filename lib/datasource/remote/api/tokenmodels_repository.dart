import 'package:async/async.dart';
import 'package:hashed/datasource/remote/api/http_repo/http_repository.dart';
import 'package:hashed/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:hashed/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:http/http.dart' as http;

/// Retrieve token metadata (used for display of currency cards etc) from
/// a table in the token master smart contract (tmastr.seeds)
class TokenModelsRepository extends HttpRepository {
  /// acceptances table in tmastr.seeds lists (by internal id) all tokens accepted for a usecase
  Future<Result<Map<String, dynamic>>> getAcceptedTokenIds(String useCase, int lowerBound) async {
    final request = createRequest(
      code: SeedsCode.accountTokenModels,
      scope: useCase,
      table: SeedsTable.tableTokenMasterAcceptances,
      lowerBound: lowerBound.toString(),
      limit: 100,
    );
    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<Map<String, dynamic>>(response, (dynamic body) {
              return body;
            }))
        .catchError((error) => mapHttpError(error));
  }

  /// master token table in tmastr.seeds contains all registered tokens for all usecases
  Future<Result<Map<String, dynamic>>> getMasterTokenTable(int lowerBound) async {
    print('[http] get token master list');
    final request = createRequest(
      code: SeedsCode.accountTokenModels,
      scope: SeedsCode.accountTokenModels.value,
      table: SeedsTable.tableTokenMasterTokens,
      lowerBound: lowerBound.toString(),
      limit: 100,
    );
    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<Map<String, dynamic>>(response, (dynamic body) {
              return body;
            }))
        .catchError((error) => mapHttpError(error));
  }

  /// schema table in tmastr.seeds defines valid token metadata
  Future<Result<Map<String, dynamic>>> getSchema() async {
    print('[http] get token master list schema');
    final request = createRequest(
      code: SeedsCode.accountTokenModels,
      scope: SeedsCode.accountTokenModels.value,
      table: SeedsTable.tableTokenMasterSchema,
      // ignore: avoid_redundant_argument_values
      limit: 1,
    );
    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<Map<String, dynamic>>(response, (dynamic body) {
              return body;
            }))
        .catchError((error) => mapHttpError(error));
  }
}
