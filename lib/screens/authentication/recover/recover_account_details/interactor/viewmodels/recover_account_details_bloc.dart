import 'dart:async';

import 'package:async/src/result/result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/authentication/recover/recover_account_details/interactor/usecase/fetch_recover_account_details_data.dart';

part 'recover_account_details_event.dart';
part 'recover_account_details_state.dart';

class RecoverAccountDetailsBloc extends Bloc<RecoverAccountDetailsEvent, RecoverAccountDetailsState> {
  RecoverAccountDetailsBloc(String userAccount) : super(RecoverAccountDetailsState.initial(userAccount)) {
    on<FetchInitialData>(_fetchInitialData);
    on<OnRefreshTapped>(_onRefreshTapped);
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountDetailsState> emit) async {
    final Result<ResultData> result = await FetchRecoverAccountDetailsData().run(state.userAccount);
    emit(state.copyWith(pageState: PageState.loading));

    if (result.isValue) {
      final data = result.asValue!.value;
      emit(state.copyWith(
        linkToActivateGuardians: data.linkToActivateGuardians,
        totalGuardiansCount: data.totalGuardiansCount,
        approvedAccount: data.approvedAccounts,
        pageState: PageState.success,
      ));
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onRefreshTapped(OnRefreshTapped event, Emitter<RecoverAccountDetailsState> emit) {
    add(const FetchInitialData());
  }
}
