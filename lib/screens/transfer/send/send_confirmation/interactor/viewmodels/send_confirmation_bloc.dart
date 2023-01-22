import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/model/transaction_results.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/mappers/initial_validation_state_mapper.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';

part 'send_confirmation_event.dart';
part 'send_confirmation_state.dart';

class SendConfirmationBloc extends Bloc<SendConfirmationEvent, SendConfirmationState> {
  SendConfirmationBloc(ScanQrCodeResultData arguments) : super(SendConfirmationState.initial(arguments)) {
    on<OnInitValidations>(_onInitValidations);
    on<OnSendTransactionButtonPressed>(_onSendTransaction);
  }

  Future<void> _onInitValidations(OnInitValidations event, Emitter<SendConfirmationState> emit) async {
    // We can extend this initial validation logic in future using a switch case for any transaction type
    // for now it only validates a transfer
    if (state.isTransfer) {
      final Result<TokenBalanceModel> result = await GetAvailableBalanceUseCase().run();
      emit(InitialValidationStateMapper().mapResultToState(state, result));
    } else {
      emit(state.copyWith(pageState: PageState.success));
    }
  }

  Future<void> _onSendTransaction(OnSendTransactionButtonPressed event, Emitter<SendConfirmationState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    // [POLKA] implement
    throw UnimplementedError();
    // final Result result = await SendTransactionUseCase().run(state.transaction, state.callback);
    // final bool shouldShowInAppReview = await inAppReview.isAvailable();
    // emit(SendTransactionStateMapper().mapResultToState(state, result, event.rates, shouldShowInAppReview));
  }
}
