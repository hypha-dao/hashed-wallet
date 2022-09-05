import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';

part 'recover_account_details_event.dart';
part 'recover_account_details_state.dart';

class RecoverAccountFoundBloc extends Bloc<RecoverAccountDetailsEvent, RecoverAccountDetailsState> {
  RecoverAccountFoundBloc(String userAccount) : super(RecoverAccountDetailsState.initial(userAccount)) {
    on<FetchInitialData>(_fetchInitialData);
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountDetailsState> emit) async {}
}
