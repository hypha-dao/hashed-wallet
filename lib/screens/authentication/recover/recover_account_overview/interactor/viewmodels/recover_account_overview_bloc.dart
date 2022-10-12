import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/authentication/recover/recover_account_overview/interactor/usecase/fetch_recover_account_overview_data.dart';
import 'package:hashed/utils/result_extension.dart';

part 'recover_account_overview_event.dart';
part 'recover_account_overview_state.dart';

class RecoverAccountOverviewBloc extends Bloc<RecoverAccountOverviewEvent, RecoverAccountOverviewState> {
  StreamSubscription? eventBusSubscription;

  @override
  Future<void> close() async {
    await eventBusSubscription?.cancel();
    return super.close();
  }

  RecoverAccountOverviewBloc() : super(RecoverAccountOverviewState.initial()) {
    eventBusSubscription = eventBus.on().listen((event) async {
      if (event is OnRecoverDataChangedEventBus) {
        add(const OnRefreshTapped());
      }
    });
    on<FetchInitialData>(_fetchInitialData);
    on<OnRefreshTapped>(_onRefreshTapped);
    on<OnRecoverAccountTapped>(_onRecoverAccountTapped);
    on<OnRecoveryInProcessTapped>(_onRecoveryInProcessTapped);
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountOverviewState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final activeRecoveryAccount = settingsStorage.activeRecoveryAccount;
    final Result<RecoveryOverviewData> result = await FetchRecoverAccountOverviewUsecase().run(
      accountService.currentAccount.address,
      lostAccount: activeRecoveryAccount,
    );
    bool showActiveRecovery = false;

    if (result.isValue) {
      if (result.asValue!.value.activeRecovery != null) {
        final lostAccount = result.asValue!.value.activeRecovery!.lostAccount;
        showActiveRecovery = !result.asValue!.value.proxyAccounts.contains(lostAccount);
      }

      emit(state.copyWith(
        pageState: PageState.success,
        activeRecovery: result.asValue!.value.activeRecovery,
        recoveredAccounts: result.asValue!.value.proxyAccounts,
        showActiveRecovery: showActiveRecovery,
      ));
    } else {
      print("Error ${result.asError!.error}");
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onRefreshTapped(OnRefreshTapped event, Emitter<RecoverAccountOverviewState> emit) {
    add(const FetchInitialData());
  }

  Future<void> _onRecoverAccountTapped(OnRecoverAccountTapped event, Emitter<RecoverAccountOverviewState> emit) async {
    emit(state.copyWith(pageCommand: NavigateToRoute(Routes.recoverAccountSearch)));
  }

  Future<void> _onRecoveryInProcessTapped(
      OnRecoveryInProcessTapped event, Emitter<RecoverAccountOverviewState> emit) async {
    emit(
      state.copyWith(
        pageCommand: NavigateToRouteWithArguments(route: Routes.recoverAccountDetails, arguments: event.lostAccount),
      ),
    );
  }
}
