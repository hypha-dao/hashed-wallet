import 'package:hashed/domain-shared/page_command.dart';

abstract class AccountUnderRecoveryEvent {
  const AccountUnderRecoveryEvent();
}

class OnStopGuardianActiveRecoveryTapped extends AccountUnderRecoveryEvent {
  const OnStopGuardianActiveRecoveryTapped();

  @override
  String toString() => 'OnStopGuardianActiveRecoveryTapped';
}

class OnShowSuccessDialogPageCommand extends PageCommand {}
