import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/model/balance_model.dart';
import 'package:hashed/datasource/remote/model/token_model.dart';
import 'package:hashed/domain-shared/base_use_case.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/wallet/components/tokens_cards/interactor/mappers/token_balances_state_mapper.dart';
import 'package:hashed/screens/wallet/components/tokens_cards/interactor/usecases/load_token_balances_use_case.dart';
import 'package:hashed/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balance_view_model.dart';

part 'token_balances_event.dart';
part 'token_balances_state.dart';

class TokenBalancesBloc extends Bloc<TokenBalancesEvent, TokenBalancesState> {
  StreamSubscription? eventBusSubscription;

  TokenBalancesBloc() : super(TokenBalancesState.initial(hashedToken)) {
    eventBusSubscription = eventBus.on().listen((event) async {
      if (event is OnNewTransactionEventBus) {
        await Future.delayed(const Duration(milliseconds: 500)); // the blockchain needs 0.5 seconds to process
        add(const OnLoadTokenBalances());
      } else if (event is OnFiatCurrencyChangedEventBus) {
        add(const OnFiatCurrencyChanged());
      } else if (event is OnWalletRefreshEventBus) {
        add(const OnLoadTokenBalances());
      }
    });
    on<OnLoadTokenBalances>(_onLoadTokenBalances);
    on<OnSelectedTokenChanged>(_onSelectedTokenChanged);
    on<OnFiatCurrencyChanged>(_onFiatCurrencyChanged);
  }

  @override
  Future<void> close() async {
    await eventBusSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadTokenBalances(OnLoadTokenBalances event, Emitter<TokenBalancesState> emit) async {
    print("on load token balances");

    emit(state.copyWith(pageState: PageState.loading));
    final List<Result<TokenBalanceModel>> result = await LoadTokenBalancesUseCase().run();
    emit(await TokenBalancesStateMapper().mapResultToState(state, result));
    settingsStorage.selectedToken = state.selectedToken.token;
  }

  void _onSelectedTokenChanged(OnSelectedTokenChanged event, Emitter<TokenBalancesState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
    settingsStorage.selectedToken = state.availableTokens[event.index].token;
  }

  void _onFiatCurrencyChanged(OnFiatCurrencyChanged event, Emitter<TokenBalancesState> emit) {
    emit(state.copyWith(pageState: PageState.loading));
    emit(state.copyWith(pageState: PageState.success));
  }
}
