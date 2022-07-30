import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/authentication/import_key/interactor/mappers/import_key_state_mapper.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/check_private_key_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/import_key_use_case.dart';

part 'import_key_event.dart';

part 'import_key_state.dart';

const int wordsMax = 12;

class ImportKeyBloc extends Bloc<ImportKeyEvent, ImportKeyState> {
  ImportKeyBloc() : super(ImportKeyState.initial()) {
    on<OnMneumonicPhraseChange>(_onMneumonicPhraseChange);
    on<FindAccountByKey>(_findAccountByKey);

    on<AccountSelected>((event, emit) => emit(state.copyWith(accountSelected: event.account)));
    on<ClearPageCommand>((event, emit) => emit(state.copyWith()));
  }

  void _onMneumonicPhraseChange(OnMneumonicPhraseChange event, Emitter<ImportKeyState> emit) {
    emit(state.copyWith(enableButton: event.newMneumonicPhrase.isNotEmpty, mneumonicPhrase: event.newMneumonicPhrase));
  }

  Future<void> _findAccountByKey(FindAccountByKey event, Emitter<ImportKeyState> emit) async {
    emit(state.copyWith(isButtonLoading: true));
    final publicKey = CheckPrivateKeyUseCase().isKeyValid(state.mneumonicPhrase);

    if (publicKey == null || publicKey.isEmpty) {
      emit(state.copyWith(error: "Invalid account phrase", isButtonLoading: false, enableButton: false));
    } else {
      final results = await ImportKeyUseCase().run(publicKey);
      emit(
        ImportKeyStateMapper().mapResultsToState(
          currentState: state,
          authData: AuthDataModel(state.mneumonicPhrase.split(" ")),
          results: results,
        ),
      );
    }
  }
}
