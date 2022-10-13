import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/domain-shared/base_use_case.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/authentication/recover/recover_account_found/interactor/viewmodels/current_remaining_time.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/usecase/fetch_recover_account_timer_data.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/usecase/recover_use_case.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/usecase/remaining_time_state_mapper.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/viewmodels/recover_account_timer_page_command.dart';

part 'recover_account_timer_event.dart';
part 'recover_account_timer_state.dart';

class RecoverAccountTimerBloc extends Bloc<RecoverAccountTimerEvent, RecoverAccountTimerState> {
  StreamSubscription<int>? _tickerSubscription;

  RecoverAccountTimerBloc(ActiveRecoveryModel recoveryModel, GuardiansConfigModel configModel)
      : super(RecoverAccountTimerState.initial(recoveryModel, configModel)) {
    on<FetchTimerData>(_fetchInitialData);
    on<OnRefreshTapped>(_onRefreshTapped);
    on<OnRecoverTapped>(_onRecoverTapped);
    on<Tick>(_onTick);
  }

  Stream<int> _tick() => Stream.periodic(const Duration(seconds: 1), (x) => x);

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Future<void> _fetchInitialData(FetchTimerData event, Emitter<RecoverAccountTimerState> emit) async {
    if (event.showLoadingIndicator) {
      emit(state.copyWith(pageState: PageState.loading));
    }
    final Result<DateTime> result =
        await FetchRecoverAccountTimerDataUseCase().run(state.recoveryModel, state.configModel);

    if (result.isValue) {
      final expirationDate = result.asValue!.value;
      emit(state.copyWith(pageState: PageState.success, timeLockExpirationDate: expirationDate));

      if (state.timeRemainingSeconds > 0) {
        await _tickerSubscription?.cancel();
        _tickerSubscription = _tick().listen((timer) => add(Tick(timer)));
      }
      emit(RemainingTimeStateMapper().mapResultToState(state));
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onRefreshTapped(OnRefreshTapped event, Emitter<RecoverAccountTimerState> emit) {
    add(const FetchTimerData(true));
  }

  Future<void> _onTick(Tick event, Emitter<RecoverAccountTimerState> emit) async {
    if (state.timeRemainingSeconds % 60 == 0) {
      add(const FetchTimerData(false));
    }
    if (state.timeRemainingSeconds > 0) {
      emit(RemainingTimeStateMapper().mapResultToState(state));
    } else {
      await _tickerSubscription?.cancel();
      emit(state.copyWith(currentRemainingTime: CurrentRemainingTime.zero()));
    }
  }

  Future<void> _onRecoverTapped(OnRecoverTapped event, Emitter<RecoverAccountTimerState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await RecoverUseCase()
        .run(rescuer: accountService.currentAccount.address, lostAccount: state.recoveryModel.lostAccount);

    if (result.isValue) {
      // show success dialog?
      print("recovery successful");
      emit(state.copyWith(pageCommand: OnRecoverSuccessPageCommand()));
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }
}
