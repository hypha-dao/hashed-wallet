import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/transfer/scan/interactor/viewmodels/scan_confirmation_commands.dart';
import 'package:hashed/screens/transfer/scan/scan_confirmation_action.dart';

part 'scan_confirmation_events.dart';
part 'scan_confirmation_state.dart';

final mockData = [
  ScanConfirmationActionData(
      actionName: MapEntry('Create Recovery', 'Recovery'), actionParams: {'One': 'One Value', 'Two': 'Two Value'}),
];

class ScanConfirmationBloc extends Bloc<ScanConfirmationEvent, ScanConfirmationState> {
  ScanConfirmationBloc() : super(ScanConfirmationState.initial()) {
    on<Initial>(_initial);
    on<OnSendTapped>(_onSendTapped);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _initial(Initial event, Emitter<ScanConfirmationState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));

    // TODO(NIK): here is where you make the calls to fetch Initial data. Inside a use case
    final Result<List<ScanConfirmationActionData>> result =
        await Future.delayed(const Duration(seconds: 2)).then((value) => Result.value(mockData));
    if (result.isValue) {
      emit(state.copyWith(
        // data: result.asValue!.value,
        pageState: PageState.success,
        // filtered: result.asValue!.value,
      ));
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onSendTapped(OnSendTapped event, Emitter<ScanConfirmationState> emit) async {
    emit(state.copyWith(actionButtonLoading: true));

    // TODO(NIK): here is where you make the calls to SEND. Inside a use case
    final Result<bool> result = await Future.delayed(const Duration(seconds: 2)).then((value) => Result.value(true));
    if (result.isValue) {
      emit(state.copyWith(
        actionButtonLoading: false,
        pageCommand: ShowTransactionSuccess(),
      ));
    } else {
      emit(state.copyWith(
        actionButtonLoading: false,
        transactionSendError: 'Error',
      ));
    }
  }
}
