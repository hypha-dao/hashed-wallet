import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/domain-shared/page_command.dart';

class OnRecoveryActivePageCommand extends PageCommand {
  final List<ActiveRecoveryModel> recoveries;
  OnRecoveryActivePageCommand(this.recoveries);
}
