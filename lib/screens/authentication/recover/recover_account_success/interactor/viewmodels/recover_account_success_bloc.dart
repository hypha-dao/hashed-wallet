import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/authentication/recover/recover_account_success/usecase/fetch_recover_account_success_data.dart';

part 'recover_account_success_event.dart';
part 'recover_account_success_state.dart';

class RecoverAccountSuccessBloc extends Bloc<RecoverAccountSuccessEvent, RecoverAccountSuccessState> {
  RecoverAccountSuccessBloc(String lostAccount) : super(RecoverAccountSuccessState.initial(lostAccount)) {
    on<FetchInitialData>(_fetchInitialData);
    on<OnRefreshTapped>(_onRefreshTapped);
    on<OnRecoverFundsTapped>(_onRecoverFundsTapped);
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountSuccessState> emit) async {
    final Result<BalanceModel> result = await FetchRecoverAccountSuccessDataUseCase().run(state.lostAccount);
    emit(state.copyWith(pageState: PageState.loading));

    if (result.isValue) {
      final data = result.asValue!.value;
      emit(state.copyWith(
        pageState: PageState.success,
        recoverAmount: TokenDataModel(data.quantity),
      ));
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onRefreshTapped(OnRefreshTapped event, Emitter<RecoverAccountSuccessState> emit) {
    add(const FetchInitialData());
  }

  FutureOr<void> _onRecoverFundsTapped(OnRecoverFundsTapped event, Emitter<RecoverAccountSuccessState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));

    final res = await polkadotRepository.recoveryRepository
        .recoverAllFunds(address: event.rescuer, lostAccount: event.lostAccount);

    if (res.isValue) {
      print("recover success ${res.asValue!.value}");
      emit(state.copyWith(pageState: PageState.success));
      add(const OnRefreshTapped());
      eventBus.fire(const OnWalletRefreshEventBus());
    } else {
      print("recover fail with error ${res.asError!.error}");
      emit(state.copyWith(pageState: PageState.failure));
    }
  }
}
