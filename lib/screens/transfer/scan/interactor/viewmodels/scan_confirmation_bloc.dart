import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:hashed/datasource/local/models/substrate_signing_request_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/local/signing_request_repository.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/transfer/scan/interactor/usecases/estimate_fee_use_case.dart';
import 'package:hashed/screens/transfer/scan/interactor/usecases/get_balance_use_case.dart';
import 'package:hashed/screens/transfer/scan/interactor/viewmodels/scan_confirmation_commands.dart';
import 'package:hashed/screens/transfer/scan/scan_confirmation_action.dart';

part 'scan_confirmation_events.dart';
part 'scan_confirmation_state.dart';

class ScanConfirmationBloc extends Bloc<ScanConfirmationEvent, ScanConfirmationState> {
  ScanConfirmationBloc() : super(ScanConfirmationState.initial()) {
    on<Initial>(_initial);
    on<OnSendTapped>(_onSendTapped);
    on<OnDoneTapped>(_onDoneTapped);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _initial(Initial event, Emitter<ScanConfirmationState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));

    Result<List<ScanConfirmationActionData>> result;
    if (event.signingRequest == null) {
      result = Result.error("No signing request");
    } else {
      if (settingsStorage.currentNetwork != event.signingRequest!.signingRequestModel.chainId) {
        result = Result.error(
            'You are on network ${settingsStorage.currentNetwork}. Please select network ${event.signingRequest!.signingRequestModel.chainId} to sign this transaction.');
      } else {
        result = Result.value(event.signingRequest!.signingRequestModel.toSendConfirmationData());
      }
    }

    final feeResult = await EstimateFeeUseCase().run(event.signingRequest!.signingRequestModel.transactions.first);
    final balanceResult = await GetBalanceUseCase().run();
    TokenBalanceModel? fee;
    if (feeResult.isValue && balanceResult.isValue) {
      fee = feeResult.asValue!.value;
      final balance = balanceResult.asValue!.value;
      final canAffordFee = fee.quantity <= balance.quantity;
      if (!canAffordFee) {
        result = Result.error(
            "Transaction fee exceeds available balance\nFee: ${fee.asAssetString}\nBalance: ${balance.asAssetString}");
      }
    } else {
      print("error getting fee or balance.");
    }

    if (result.isValue) {
      emit(state.copyWith(
        actions: result.asValue!.value,
        signingRequest: event.signingRequest!.signingRequestModel,
        fee: fee,
        pageState: PageState.success,
      ));
    } else {
      emit(
        state.copyWith(
            pageState: PageState.success, actions: [], transactionSendError: result.asError!.error.toString()),
      );
    }
  }

  FutureOr<void> _onDoneTapped(OnDoneTapped event, Emitter<ScanConfirmationState> emit) {
    emit(state.copyWith(pageCommand: NavigateHome()));
  }

  FutureOr<void> _onSendTapped(OnSendTapped event, Emitter<ScanConfirmationState> emit) async {
    emit(state.copyWith(actionButtonLoading: true));

    final result = await SigningRequestRepository()
        .signAndSendSigningRequest(state.signingRequest!, accountService.currentAccount.address);

    eventBus.fire(const OnNewTransactionEventBus());

    if (result.isValue) {
      emit(state.copyWith(
        actionButtonLoading: false,
        pageCommand: ShowTransactionSuccess(),
      ));
    } else {
      emit(state.copyWith(
        actionButtonLoading: false,
        transactionSendError: 'Error: ${result.asError!.error.toString()}',
      ));
    }
  }
}
