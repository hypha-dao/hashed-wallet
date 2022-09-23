import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/remote/api/guardians_repository.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/datasource/remote/polkadot_api/recovery_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/authentication/recover/recover_account_success/usecase/fetch_recover_account_success_data.dart';

part 'recover_account_success_event.dart';
part 'recover_account_success_state.dart';

class RecoverAccountSuccessBloc extends Bloc<RecoverAccountSuccessEvent, RecoverAccountSuccessState> {
  RecoverAccountSuccessBloc(String userAccount) : super(RecoverAccountSuccessState.initial(userAccount)) {
    on<FetchInitialData>(_fetchInitialData);
    on<OnRefreshTapped>(_onRefreshTapped);
    on<OnRecoverFundsTapped>(_onRecoverFundsTapped);
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountSuccessState> emit) async {
    final Result<ResultData> result = await FetchRecoverAccountSuccessData().run(state.userAccount);
    emit(state.copyWith(pageState: PageState.loading));

    if (result.isValue) {
      final data = result.asValue!.value;
      emit(state.copyWith(
        pageState: PageState.success,
        recoveredAccount: data.recoveredAccount,
        recoverAmount: data.amountToRecover,
      ));
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onRefreshTapped(OnRefreshTapped event, Emitter<RecoverAccountSuccessState> emit) {
    add(const FetchInitialData());
  }

  FutureOr<void> _onRecoverFundsTapped(OnRecoverFundsTapped event, Emitter<RecoverAccountSuccessState> emit) {
    polkadotRepository.recoveryRepository.recoverAllFunds(address: event.rescuer, lostAccount: event.lostAccount);
  }
}
