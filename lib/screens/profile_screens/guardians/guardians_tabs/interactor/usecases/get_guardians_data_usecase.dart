import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardians_data.dart';

class GetGuardiansDataUseCase {
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  GuardiansData getGuardiansData() {
    return _repository.getGuardiansDataForUser(accountService.currentAccount.address);
  }
}
