import 'package:bloc/bloc.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';

part 'recovery_phrase_event.dart';
part 'recovery_phrase_state.dart';

class RecoveryPhraseBloc extends Bloc<RecoveryPhraseEvent, RecoveryPhraseState> {
  RecoveryPhraseBloc()
      : super(RecoveryPhraseState.initial(AuthDataModel.fromString(
          "todo", // TODO(n13): get recovery words in here
        )));
}
