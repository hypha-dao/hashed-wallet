import 'package:hashed/datasource/local/models/substrate_signing_request_model.dart';
import 'package:hashed/domain-shared/page_command.dart';

class BottomBarNavigateToIndex extends PageCommand {
  final int index;

  BottomBarNavigateToIndex(this.index);
}

class ProcessSigningRequest extends PageCommand {
  final SubstrateSigningRequestModel model;

  ProcessSigningRequest(this.model);
}
