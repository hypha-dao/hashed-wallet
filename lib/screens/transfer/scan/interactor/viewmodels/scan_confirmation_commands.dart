import 'package:hashed/domain-shared/page_command.dart';

abstract class ScanPageCommand extends PageCommand {}

class ShowTransactionSuccess extends ScanPageCommand {
  ShowTransactionSuccess();
}

class NavigateHome extends ScanPageCommand {
  NavigateHome();
}
