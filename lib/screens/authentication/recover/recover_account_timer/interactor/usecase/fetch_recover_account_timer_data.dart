import 'package:hashed/datasource/remote/api/guardians_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class FetchRecoverAccountTimerData {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result<int>> run(String accountName) async {
    // TODO(Nik): This is mocked data. We need to make calls to the repo to get the data we need and Map it to a
    // TODO(Nik): ResultData object. The bloc will know how to handle this object. If fails, return Result.error()
    return Result.value(DateTime.now().add(const Duration(hours: 23)).millisecondsSinceEpoch ~/ 1000);
  }
}
