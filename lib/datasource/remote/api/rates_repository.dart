import 'package:async/async.dart';
import 'package:hashed/datasource/remote/api/http_repo/http_repository.dart';
import 'package:hashed/datasource/remote/model/fiat_rate_model.dart';
import 'package:http/http.dart' as http;

class RatesRepository extends HttpRepository {
  Future<Result<FiatRateModel>> getFiatRates() {
    print("[http] get fiat rates");

    return http
        .get(Uri.parse("https://api-payment.hypha.earth/fiatExchangeRates?api_key=$fxApiKey"))
        .then((http.Response response) => mapHttpResponse<FiatRateModel>(response, (dynamic body) {
              return FiatRateModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
