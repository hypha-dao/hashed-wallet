import 'package:async/async.dart';
import 'package:hashed/datasource/remote/api/http_repo/http_repository.dart';
import 'package:hashed/datasource/remote/model/profile_model.dart';
import 'package:http/http.dart' as http;

class MembersRepository extends HttpRepository {
  Future<Result<List<ProfileModel>>> getFullNameSearchMembers(String filter) async {
    print("[http] getFullNameSearchMembers $filter");

    final mongoUrl = Uri.parse("https://mongo-api.hypha.earth/find");

    final params = '''
    {
      "collection": "accts.seeds-users",
      "query": {
          "nickname": {
              "\$regex": "$filter",
              "\$options": "i"
          }
      },
      "projection": {},
      "sort": {
          "block_num": -1
      },
      "skip": 0,
      "limit": 20,
      "reverse": false
    }
    ''';

    return http
        .post(mongoUrl, headers: headers, body: params)
        .then((http.Response response) => mapHttpResponse<List<ProfileModel>>(response, (dynamic body) {
              final allAccounts = body['items'].toList() as List<Map<String, dynamic>>;
              return allAccounts.map((item) => ProfileModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }
}
