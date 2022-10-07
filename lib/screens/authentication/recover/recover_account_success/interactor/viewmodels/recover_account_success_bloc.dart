import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/shared_use_cases/get_active_recovery_for_lost_account_use_case.dart';
import 'package:hashed/screens/authentication/recover/recover_account_success/interactor/viewmodels/recover_account_success_page_command.dart';
import 'package:hashed/screens/authentication/recover/recover_account_success/usecase/fetch_recover_account_success_data.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/get_guardians_data_usecase.dart';

part 'recover_account_success_event.dart';
part 'recover_account_success_state.dart';

class RecoverAccountSuccessBloc extends Bloc<RecoverAccountSuccessEvent, RecoverAccountSuccessState> {
  RecoverAccountSuccessBloc(String lostAccount) : super(RecoverAccountSuccessState.initial(lostAccount)) {
    on<FetchInitialData>(_fetchInitialData);
    on<OnRefreshTapped>(_onRefreshTapped);
    on<OnRecoverFundsTapped>(_onRecoverFundsTapped);
    on<OnCleanupAndRemoveTapped>(_onCleanupAndRemoveTapped);
    on<OnRemoveGuardiansConfigTapped>(_onRemoveGuardiansConfigTapped);
    on<OnRemoveActiveRecoveryTapped>(_onRemoveActiveRecoveryTapped);
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountSuccessState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));

    final res = await Future.wait([
      FetchRecoverAccountSuccessDataUseCase().run(state.lostAccount),
      GetGuardiansConfigUseCase().getGuardiansData(state.lostAccount),
      GetActiveRecoveryForLostAccountUseCase()
          .run(rescuer: accountService.currentAccount.address, lostAccount: state.lostAccount),
    ]);
    final balanceResult = res[0] as Result<BalanceModel>;
    final configResult = res[1] as Result<GuardiansConfigModel>;
    final activeResult = res[2] as Result<ActiveRecoveryModel?>;

    final config = configResult.isValue ? configResult.asValue!.value : null;
    final active = activeResult.isValue ? activeResult.asValue!.value : null;

    if (balanceResult.isValue) {
      final data = balanceResult.asValue!.value;
      emit(state.copyWith(
        pageState: PageState.success,
        recoverAmount: TokenDataModel(data.quantity),
        guardiansConfig: config,
        activeRecoveryModel: active,
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

  FutureOr<void> _onCleanupAndRemoveTapped(
      OnCleanupAndRemoveTapped event, Emitter<RecoverAccountSuccessState> emit) async {
    print("cleanup and remove");
    emit(state.copyWith(pageState: PageState.loading));

    final account = accountService.currentAccount.address;

    final res = await polkadotRepository.recoveryRepository.cancelRecovered(
      account: account,
      lostAccount: state.lostAccount,
    );

    if (res.isValue) {
      print("cancel success ${res.asValue!.value}");
      emit(state.copyWith(
        pageState: PageState.success,
        pageCommand: ShowCancelCompleteDialogPageCommand(),
      ));
      add(const OnRefreshTapped());
      eventBus.fire(const OnWalletRefreshEventBus());
      eventBus.fire(const OnRecoverDataChangedEventBus());
    } else {
      print("cancel fail with error ${res.asError!.error}");
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onRemoveGuardiansConfigTapped(
      OnRemoveGuardiansConfigTapped event, Emitter<RecoverAccountSuccessState> emit) async {
    print("remove guardians tapped");
    emit(state.copyWith(pageState: PageState.loading));

    final account = accountService.currentAccount.address;

    final res = await polkadotRepository.recoveryRepository
        .removeRecoveryConfiguration(address: state.lostAccount, proxy: account);

    if (res.isValue) {
      print("remove config success ${res.asValue!.value}");
      emit(state.copyWith(pageState: PageState.success, guardiansConfig: GuardiansConfigModel.empty()));
      add(const OnRefreshTapped());
      eventBus.fire(const OnWalletRefreshEventBus());
      eventBus.fire(const OnRecoverDataChangedEventBus());
    } else {
      print("remove config fail with error ${res.asError!.error}");
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onRemoveActiveRecoveryTapped(
      OnRemoveActiveRecoveryTapped event, Emitter<RecoverAccountSuccessState> emit) async {
    print("on remove active recovery");
    emit(state.copyWith(pageState: PageState.loading));

    final account = accountService.currentAccount.address;

    final res = await polkadotRepository.recoveryRepository
        .closeRecovery(lostAccount: state.lostAccount, rescuer: account, proxy: account);

    if (res.isValue) {
      print("remove active recovery ${res.asValue!.value}");
      emit(state.copyWith(pageState: PageState.success, guardiansConfig: GuardiansConfigModel.empty()));
      add(const OnRefreshTapped());
      eventBus.fire(const OnWalletRefreshEventBus());
      eventBus.fire(const OnRecoverDataChangedEventBus());
    } else {
      print("remove active recovery fail with error ${res.asError!.error}");
      emit(state.copyWith(pageState: PageState.failure));
    }
  }
}
