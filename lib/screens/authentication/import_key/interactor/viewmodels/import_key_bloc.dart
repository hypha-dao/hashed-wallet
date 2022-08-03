import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/check_private_key_use_case.dart';

part 'import_key_event.dart';

part 'import_key_state.dart';

const int wordsMax = 12;

class ImportKeyBloc extends Bloc<ImportKeyEvent, ImportKeyState> {
  ImportKeyBloc() : super(ImportKeyState.initial()) {
    on<OnMnemonicPhraseChange>(_onMnemonicPhraseChange);
    on<GetAccountByKey>(_findAccountByKey);

    on<AccountSelected>((event, emit) => emit(state.copyWith(accountSelected: event.account)));
    on<ClearPageCommand>((event, emit) => emit(state.copyWith()));
  }

  void _onMnemonicPhraseChange(OnMnemonicPhraseChange event, Emitter<ImportKeyState> emit) {
    emit(state.copyWith(enableButton: event.newMnemonicPhrase.isNotEmpty, mnemonicPhrase: event.newMnemonicPhrase));
  }

  Future<void> _findAccountByKey(GetAccountByKey event, Emitter<ImportKeyState> emit) async {
    emit(state.copyWith(isButtonLoading: true));
    final publicKey = await CheckPrivateKeyUseCase().isKeyValid(state.mnemonicPhrase);

    if (publicKey == null || publicKey.isEmpty) {
      emit(state.copyWith(error: "Invalid account phrase", isButtonLoading: false, enableButton: false));
    } else {
      final autData = AuthDataModel.fromString(state.mnemonicPhrase);
      emit(
        state.copyWith(
          isButtonLoading: false,
          accounts: [publicKey],
          authData: autData,
          pageCommand: NavigateToRouteWithArguments(route: Routes.createNickname, arguments: [publicKey, autData]),
        ),
      );
    }
  }
}
