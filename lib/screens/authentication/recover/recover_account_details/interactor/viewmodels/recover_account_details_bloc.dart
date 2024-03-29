import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/authentication/recover/recover_account_details/interactor/usecase/fetch_recover_account_details_data.dart';
import 'package:hashed/utils/result_extension.dart';

part 'recover_account_details_event.dart';
part 'recover_account_details_state.dart';

class RecoverAccountDetailsBloc extends Bloc<RecoverAccountDetailsEvent, RecoverAccountDetailsState> {
  RecoverAccountDetailsBloc(String userAccount) : super(RecoverAccountDetailsState.initial(userAccount)) {
    on<FetchInitialData>(_fetchInitialData);
    on<OnRefreshTapped>(_onRefreshTapped);
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountDetailsState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<RecoveryResultData> result =
        await FetchRecoverAccountDetailsUsecase().run(accountService.currentAccount.address, state.lostAccount);

    if (result.isValue) {
      final data = result.asValue!.value;
      emit(state.copyWith(
        linkToActivateGuardians: data.linkToActivateGuardians,
        totalGuardiansCount: data.configuration.guardianAddresses.length,
        approvedAccounts: data.activeRecovery.friends,
        guardianAccounts: data.configuration.guardianAddresses,
        threshold: data.configuration.threshold,
        pageState: PageState.success,
      ));
      if (data.activeRecovery.isNotEmpty && data.activeRecovery.friends.length >= data.configuration.threshold) {
        emit(state.copyWith(
            pageCommand: NavigateToRouteWithArguments(route: Routes.recoverAccountTimer, arguments: data)));
      }
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onRefreshTapped(OnRefreshTapped event, Emitter<RecoverAccountDetailsState> emit) {
    add(const FetchInitialData());
  }
}
