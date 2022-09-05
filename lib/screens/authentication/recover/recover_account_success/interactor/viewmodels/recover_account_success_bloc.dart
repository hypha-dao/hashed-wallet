import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';

part 'recover_account_success_event.dart';
part 'recover_account_success_state.dart';

class RecoverAccountSuccessBloc extends Bloc<RecoverAccountSuccessEvent, RecoverAccountSuccessState> {
  RecoverAccountSuccessBloc(String userAccount) : super(RecoverAccountSuccessState.initial(userAccount)) {
    on<FetchInitialData>(_fetchInitialData);
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountSuccessState> emit) async {}
}
