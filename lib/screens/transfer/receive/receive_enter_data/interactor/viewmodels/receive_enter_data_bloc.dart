import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:hashed/screens/transfer/receive/receive_enter_data/interactor/mappers/create_invoice_result_mapper.dart';
import 'package:hashed/screens/transfer/receive/receive_enter_data/interactor/mappers/user_balance_state_mapper.dart';
import 'package:hashed/screens/transfer/receive/receive_enter_data/interactor/usecases/receive_seeds_invoice_use_case.dart';
import 'package:hashed/utils/rate_states_extensions.dart';

part 'receive_enter_data_event.dart';
part 'receive_enter_data_state.dart';

class ReceiveEnterDataBloc extends Bloc<ReceiveEnterDataEvent, ReceiveEnterDataState> {
  ReceiveEnterDataBloc(RatesState rates) : super(ReceiveEnterDataState.initial(rates)) {
    on<LoadUserBalance>(_loadUserBalance);
    on<OnAmountChange>(_onAmountChange);
    on<OnMemoChanged>((event, emit) => emit(state.copyWith(memo: event.memo)));
    on<OnNextButtonTapped>(_onNextButtonTapped);
    on<ClearReceiveEnterDataState>(_clearReceiveEnterDataState);
  }

  Future<void> _loadUserBalance(LoadUserBalance event, Emitter<ReceiveEnterDataState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<TokenBalanceModel> result = await GetAvailableBalanceUseCase().run();
    emit(UserBalanceStateMapper().mapResultToState(state, result));
  }

  void _onAmountChange(OnAmountChange event, Emitter<ReceiveEnterDataState> emit) {
    final double parsedQuantity = double.tryParse(event.amountChanged) ?? 0;
    final tokenAmount = TokenDataModel(parsedQuantity, token: settingsStorage.selectedToken);
    final fiatAmount = state.ratesState.tokenToFiat(tokenAmount, settingsStorage.selectedFiatCurrency);
    emit(state.copyWith(isNextButtonEnabled: parsedQuantity > 0, tokenAmount: tokenAmount, fiatAmount: fiatAmount));
  }

  Future<void> _onNextButtonTapped(OnNextButtonTapped event, Emitter<ReceiveEnterDataState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<ReceiveInvoiceResponse> result = await ReceiveInvoiceUseCase()
        .run(ReceiveInvoiceUseCase.input(tokenAmount: state.tokenAmount, memo: state.memo));
    emit(CreateInvoiceResultMapper().mapResultToState(state, result));
  }

  void _clearReceiveEnterDataState(ClearReceiveEnterDataState event, Emitter<ReceiveEnterDataState> emit) {
    emit(state.copyWith(
      fiatAmount: FiatDataModel(0),
      isNextButtonEnabled: false,
      tokenAmount: TokenDataModel.fromSelected(0),
      isAutoFocus: false,
    ));
  }
}
