import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/base_use_case.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/interactor/mappers/send_amount_change_mapper.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/interactor/mappers/send_enter_data_state_mapper.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/interactor/mappers/send_transaction_mapper.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/interactor/viewmodels/show_send_confirm_dialog_data.dart';

part 'send_enter_data_event.dart';
part 'send_enter_data_state.dart';

class SendEnterDataBloc extends Bloc<SendEnterDataEvent, SendEnterDataState> {
  SendEnterDataBloc(Account account, RatesState rates) : super(SendEnterDataState.initial(account, rates)) {
    on<InitSendDataArguments>(_initSendDataArguments);
    on<OnMemoChange>((event, emit) => emit(state.copyWith(memo: event.memoChanged)));
    on<OnAmountChange>(_onAmountChange);
    on<OnNextButtonTapped>(_onNextButtonTapped);
    on<OnSendButtonTapped>(_onSendButtonTapped);
    on<ClearSendEnterDataPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _initSendDataArguments(InitSendDataArguments event, Emitter<SendEnterDataState> emit) async {
    emit(state.copyWith(pageState: PageState.loading, showSendingAnimation: false));
    final Result<TokenBalanceModel> result = await GetAvailableBalanceUseCase().run();
    emit(SendEnterDataStateMapper().mapResultToState(state, result, state.ratesState, 0.toString()));
  }

  void _onAmountChange(OnAmountChange event, Emitter<SendEnterDataState> emit) {
    emit(SendAmountChangeMapper().mapResultToState(state, state.ratesState, event.amountChanged));
  }

  void _onNextButtonTapped(OnNextButtonTapped event, Emitter<SendEnterDataState> emit) {
    emit(state.copyWith(
      pageState: PageState.success,
      shouldAutoFocusEnterField: false,
      pageCommand: ShowSendConfirmDialog(
        tokenAmount: state.tokenAmount,
        toAccount: state.sendTo.address,
        memo: state.memo,
        toName: state.sendTo.name,
        //toImage: state.sendTo.image,
        fiatAmount: state.fiatAmount,
      ),
    ));
  }

  Future<void> _onSendButtonTapped(OnSendButtonTapped event, Emitter<SendEnterDataState> emit) async {
    emit(state.copyWith(pageState: PageState.loading, showSendingAnimation: true));
    final result = await polkadotRepository.balancesRepository.sendTransfer(
        from: accountService.currentAccount.address, to: state.sendTo.address, amount: state.tokenAmount.unitAmount());
    emit(SendTransactionMapper().mapResultToState(state, result));
  }
}
