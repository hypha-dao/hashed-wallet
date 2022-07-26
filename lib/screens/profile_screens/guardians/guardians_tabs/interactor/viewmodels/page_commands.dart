import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

class ShowRemoveGuardianView extends PageCommand {
  final GuardianModel guardian;

  ShowRemoveGuardianView(this.guardian);
}

class ShowRecoveryStarted extends PageCommand {
  final GuardianModel guardian;

  ShowRecoveryStarted(this.guardian);
}

class ShowResetGuardians extends PageCommand {
  ShowResetGuardians();
}

class ShowActivateGuardians extends PageCommand {
  ShowActivateGuardians();
}
