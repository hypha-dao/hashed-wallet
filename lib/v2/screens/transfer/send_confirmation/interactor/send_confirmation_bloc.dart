import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/mappers/send_transaction_state_mapper.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/usecases/send_transaction_use_case.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_confirmation_events.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_info_line_items.dart';
import 'package:seeds/v2/utils/cap_utils.dart';

/// --- BLOC
class SendConfirmationBloc extends Bloc<SendConfirmationEvent, SendConfirmationState> {
  SendConfirmationBloc() : super(SendConfirmationState.initial());

  @override
  Stream<SendConfirmationState> mapEventToState(SendConfirmationEvent event) async* {
    if (event is InitSendConfirmationWithArguments) {
      yield state.copyWith(
        pageState: PageState.success,
        lineItems: event.arguments.data!.entries
            .map((e) => SendInfoLineItems(label: e.key.inCaps, text: e.value.toString()))
            .toList(),
        name: event.arguments.name,
        account: event.arguments.account,
        data: event.arguments.data
      );
    } else if (event is SendTransactionEvent) {
      yield state.copyWith(pageState: PageState.loading);

      Result result = await SendTransactionUseCase().run(state.name, state.account, state.data);

      yield SendTransactionStateMapper().mapResultToState(state, result, event.rates);
    }
  }
}