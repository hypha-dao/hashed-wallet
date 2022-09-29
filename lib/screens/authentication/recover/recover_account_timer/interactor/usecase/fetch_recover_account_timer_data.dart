import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class FetchRecoverAccountTimerData {
  Future<Result<int>> run(ActiveRecoveryModel model) async {
    // TODO(Nik): This is mocked data. We need to make calls to the repo to get the data we need and Map it to a
    // TODO(Nik): ResultData object. The bloc will know how to handle this object. If fails, return Result.error()

    // Would be nicer to return a Duration object here
    print("TBD: IMPLEMENT THIS");

    return Result.value(DateTime.now().add(const Duration(hours: 23)).millisecondsSinceEpoch ~/ 1000);
  }
}
