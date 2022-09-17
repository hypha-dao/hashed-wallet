import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/domain-shared/base_use_case.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/authentication/recover/recover_account_found/interactor/viewmodels/current_remaining_time.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/usecase/fetch_recover_account_timer_data.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/usecase/remaining_time_state_mapper.dart';

part 'recover_account_timer_event.dart';
part 'recover_account_timer_state.dart';

class RecoverAccountTimerBloc extends Bloc<RecoverAccountTimerEvent, RecoverAccountTimerState> {
  StreamSubscription<int>? _tickerSubscription;

  RecoverAccountTimerBloc(String userAccount) : super(RecoverAccountTimerState.initial(userAccount)) {
    on<FetchInitialData>(_fetchInitialData);
    on<OnRefreshTapped>(_onRefreshTapped);
    on<Tick>(_onTick);
  }

  Stream<int> _tick() => Stream.periodic(const Duration(seconds: 1), (x) => x);

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountTimerState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<int> result = await FetchRecoverAccountTimerData().run(state.userAccount);

    if (result.isValue) {
      final data = result.asValue!.value;
      emit(state.copyWith(pageState: PageState.success, timeLockExpirySeconds: data));

      if (data != 0) {
        await _tickerSubscription?.cancel();
        _tickerSubscription = _tick().listen((timer) => add(Tick(timer)));
      }
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onRefreshTapped(OnRefreshTapped event, Emitter<RecoverAccountTimerState> emit) {
    add(const FetchInitialData());
  }

  Future<void> _onTick(Tick event, Emitter<RecoverAccountTimerState> emit) async {
    if (state.timeRemaining > 0) {
      emit(RemainingTimeStateMapper().mapResultToState(state));
    } else {
      await _tickerSubscription?.cancel();
      emit(state.copyWith(currentRemainingTime: CurrentRemainingTime.zero()));
    }
  }
}
