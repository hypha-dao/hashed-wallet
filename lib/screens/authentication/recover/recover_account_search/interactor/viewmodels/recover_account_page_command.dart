import 'package:hashed/domain-shared/page_command.dart';

class NavigateToRecoverAccountFound extends PageCommand {
  final String userAccount;

  NavigateToRecoverAccountFound(this.userAccount);
}

class ShowRecoverAccountConfirmation extends PageCommand {
  final String userAccount;

  ShowRecoverAccountConfirmation(this.userAccount);
}
