import 'package:hashed/domain-shared/page_command.dart';

class SendTextInputDataBack extends PageCommand {
  final String textToSend;

  SendTextInputDataBack(this.textToSend);
}
