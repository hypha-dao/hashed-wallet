import 'package:hashed/crypto/dart_esr/dart_esr.dart';
import 'package:hashed/domain-shared/page_command.dart';

class BottomBarNavigateToIndex extends PageCommand {
  final int index;

  BottomBarNavigateToIndex(this.index);
}

class ProcessSigningRequest extends PageCommand {
  final Action action;

  ProcessSigningRequest(this.action);
}
