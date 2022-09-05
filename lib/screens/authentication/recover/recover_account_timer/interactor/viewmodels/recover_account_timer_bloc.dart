import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';

part 'recover_account_timer_event.dart';
part 'recover_account_timer_state.dart';

class RecoverAccountTimerBloc extends Bloc<RecoverAccountTimerEvent, RecoverAccountTimerState> {
  RecoverAccountTimerBloc(String userAccount) : super(RecoverAccountTimerState.initial(userAccount)) {
    on<FetchInitialData>(_fetchInitialData);
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountTimerState> emit) async {}
}
