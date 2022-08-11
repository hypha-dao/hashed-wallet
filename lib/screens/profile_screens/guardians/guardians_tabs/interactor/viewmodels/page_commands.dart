import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/domain-shared/page_command.dart';

class ShowRemoveGuardianView extends PageCommand {
  final Account guardian;

  ShowRemoveGuardianView(this.guardian);
}

class ShowRecoveryStarted extends PageCommand {
  final Account guardian;

  ShowRecoveryStarted(this.guardian);
}

class ShowResetGuardians extends PageCommand {
  ShowResetGuardians();
}

class ShowActivateGuardians extends PageCommand {
  ShowActivateGuardians();
}
