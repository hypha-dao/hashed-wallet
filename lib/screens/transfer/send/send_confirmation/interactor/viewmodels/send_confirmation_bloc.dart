import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/local/models/eos_transaction.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/model/token_model.dart';
import 'package:hashed/datasource/remote/model/transaction_results.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/mappers/initial_validation_state_mapper.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:in_app_review/in_app_review.dart';

part 'send_confirmation_event.dart';
part 'send_confirmation_state.dart';

class SendConfirmationBloc extends Bloc<SendConfirmationEvent, SendConfirmationState> {
  final InAppReview inAppReview = InAppReview.instance;

  SendConfirmationBloc(SendConfirmationArguments arguments) : super(SendConfirmationState.initial(arguments)) {
    on<OnInitValidations>(_onInitValidations);
    on<OnSendTransactionButtonPressed>(_onSendTransaction);
  }

  Future<void> _onInitValidations(OnInitValidations event, Emitter<SendConfirmationState> emit) async {
    // We can extend this initial validation logic in future using a switch case for any transaction type
    // for now it only validates a transfer
    if (state.isTransfer) {
      final esoAction = state.transaction.actions.first;
      final symbol = (esoAction.data?['quantity'] as String).split(' ').last;
      final targetToken = TokenModel.allTokens.singleWhereOrNull((i) => i.symbol == symbol);
      if (targetToken != null) {
        final Result<BalanceModel> result = await GetAvailableBalanceUseCase().run(targetToken);
        emit(InitialValidationStateMapper().mapResultToState(state, result));
      }
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
