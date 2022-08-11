import 'package:hashed/datasource/local/models/auth_data_model.dart';
import 'package:hashed/domain-shared/page_command.dart';

class OnAccountNameGenerated extends PageCommand {}

class StartScan extends PageCommand {}

class OnAccountCreated extends PageCommand {
  final AuthDataModel authData;
  OnAccountCreated(this.authData);
}

class ReturnToLogin extends PageCommand {}
