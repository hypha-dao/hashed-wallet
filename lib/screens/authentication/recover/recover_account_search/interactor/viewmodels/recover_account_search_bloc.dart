import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/remote/model/profile_model.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/authentication/recover/recover_account_search/interactor/mappers/fetch_account_guardians_state_mapper.dart';
import 'package:hashed/screens/authentication/recover/recover_account_search/interactor/mappers/fetch_account_info_state_mapper.dart';
import 'package:hashed/screens/authentication/recover/recover_account_search/interactor/usecases/fetch_account_guardians_use_case.dart';
import 'package:hashed/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_page_command.dart';
import 'package:hashed/screens/authentication/recover/recover_account_search/recover_account_search_errors.dart';

part 'recover_account_search_event.dart';
part 'recover_account_search_state.dart';

class RecoverAccountSearchBloc extends Bloc<RecoverAccountSearchEvent, RecoverAccountSearchState> {
  RecoverAccountSearchBloc() : super(RecoverAccountSearchState.initial()) {
    on<OnUsernameChanged>(_onUsernameChanged);
    on<OnNextButtonTapped>(_onNextButtonTapped);
  }

  Future<void> _onUsernameChanged(OnUsernameChanged event, Emitter<RecoverAccountSearchState> emit) async {
    if (event.userName.length == 12) {
      emit(state.copyWith(pageState: PageState.loading));
      final userInfo = Result.value("value");
      final result = await FetchAccountRecoveryUseCase().run(event.userName);
      emit(FetchAccountGuardiansStateMapper().mapResultToState(state, result));
      emit(FetchAccountInfoStateMapper().mapResultToState(state, userInfo, event.userName));
    } else {
      emit(state.copyWith(isGuardianActive: false));
    }
  }

  void _onNextButtonTapped(OnNextButtonTapped event, Emitter<RecoverAccountSearchState> emit) {
    if (state.isGuardianActive) {
      emit(state.copyWith(pageCommand: NavigateToRecoverAccountFound(state.accountInfo!.account)));
    }
  }
}
