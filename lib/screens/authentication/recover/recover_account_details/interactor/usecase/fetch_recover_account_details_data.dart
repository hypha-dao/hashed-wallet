import 'package:hashed/datasource/remote/api/guardians_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class FetchRecoverAccountDetailsData {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result<ResultData>> run(String accountName) async {
    // TODO(Nik): This is mocked data. We need to make calls to the repo to get the data we need and Map it to a
    // TODO(Nik): ResultData object. The bloc will know how to handle this object. If fails, return Result.error()
    return Result.value(ResultData(
      totalGuardiansCount: 3,
      linkToActivateGuardians: Uri.parse('www.thehashedwallet.com/1j2k5hj4k3l'),
      approvedAccounts: ['2345678909876', '4567890987654567'],
    ));
  }
}

class ResultData {
  final Uri linkToActivateGuardians;
  final int totalGuardiansCount;
  final List<String> approvedAccounts;

  ResultData({
    required this.linkToActivateGuardians,
    required this.totalGuardiansCount,
    required this.approvedAccounts,
  });
}
