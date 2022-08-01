import 'package:async/async.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';

class CreateAccountUseCase {
  Future<Result> run({
    required String displayName,
    required String accountName,
    required AuthDataModel authData,
    String? phoneNumber,
  }) async {
    throw UnimplementedError("TODO - adopt for polkadot");
  }
}
