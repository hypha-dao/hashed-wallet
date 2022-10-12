import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_page_command.dart';

part 'recover_account_search_event.dart';
part 'recover_account_search_state.dart';

class RecoverAccountSearchBloc extends Bloc<RecoverAccountSearchEvent, RecoverAccountSearchState> {
  final AccountService _accountService;
  final PolkadotRepository _polkadotRepository;

  RecoverAccountSearchBloc(this._accountService, this._polkadotRepository)
      : super(RecoverAccountSearchState.initial()) {
    on<OnAccountChanged>(_onAccountChanged);
    on<OnNextButtonTapped>(_onNextButtonTapped);
    on<OnConfirmRecoverTapped>(_onConfirmRecoverTapped);
    on<ClearPageCommand>((event, emit) => emit(state.copyWith()));
  }

  Future<void> _onAccountChanged(OnAccountChanged event, Emitter<RecoverAccountSearchState> emit) async {
    emit(state.copyWith(account: event.account, isNextEnabled: event.account.isNotEmpty));
  }

  void _onNextButtonTapped(OnNextButtonTapped event, Emitter<RecoverAccountSearchState> emit) {
    emit(state.copyWith(pageCommand: ShowRecoverAccountConfirmation(state.account!)));
  }

  FutureOr<void> _onConfirmRecoverTapped(OnConfirmRecoverTapped event, Emitter<RecoverAccountSearchState> emit) async {
    emit(state.copyWith(isNextLoading: true));

    final lostAccount = state.account!;

    final address = _accountService.currentAccount.address;

    final existing = await _polkadotRepository.recoveryRepository
        .getActiveRecoveriesForLostaccount(rescuer: address, lostAccount: lostAccount);

    if (existing.isValue && existing.asValue!.value.isNotEmpty) {
      /// A recovery for this rescuer, lost account already exists
      print("rexocery exists: ");
      settingsStorage.activeRecoveryAccount = lostAccount;
      emit(state.copyWith(isNextLoading: false));

      emit(state.copyWith(
          isNextLoading: false,
          pageCommand: NavigateToRouteWithArguments<String>(
            route: Routes.recoverAccountDetails,
            arguments: lostAccount,
          )));
    } else {
      final result = await _polkadotRepository.recoveryRepository.initiateRecovery(
        rescuer: address,
        lostAccount: lostAccount,
      );
      emit(state.copyWith(isNextLoading: false));

      if (result.isValue) {
        settingsStorage.activeRecoveryAccount = lostAccount;
        emit(state.copyWith(
            pageCommand: NavigateToRouteWithArguments<String>(
          route: Routes.recoverAccountDetails,
          arguments: lostAccount,
        )));
      } else {
        emit(state.copyWith(
          pageCommand: ShowErrorMessage(result.asError?.error.toString() ?? 'Oops, something went wrong'),
        ));
      }
    }
  }
}
