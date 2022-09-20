import 'package:hashed/datasource/remote/api/guardians_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class FetchRecoverAccountSuccessData {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result<ResultData>> run(String accountName) async {
    // TODO(Nik): This is mocked data. We need to make calls to the repo to get the data we need and Map it to a
    // TODO(Nik): ResultData object. The bloc will know how to handle this object. If fails, return Result.error()
    return Result.value(
      ResultData(amountToRecover: 135000, recoveredAccount: '5FyG1HpMSce9As8Uju4rEQnL24LZ8QNFDaKiu5nQtX6CY6BH'),
    );
  }
}

class ResultData {
  final double amountToRecover;
  final String recoveredAccount;

  ResultData({
    required this.amountToRecover,
    required this.recoveredAccount,
  });
}
