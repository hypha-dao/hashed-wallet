import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/datasource/remote/model/profile_model.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/shared_use_cases/get_active_recovery_use_case.dart';
import 'package:hashed/screens/wallet/interactor/mappers/active_recovery_state_mapper.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  StreamSubscription? eventBusSubscription;

  WalletBloc() : super(WalletState.initial()) {
    eventBusSubscription = eventBus.on().listen((event) async {
      if (event is OnConnectionStateEventBus) {
        add(OnConnectionEvent(event.connected));
      }
    });

    on<OnLoadWalletData>(_onLoadWalletData);
    on<OnConnectionEvent>(_onConnectionEvent);
  }
  @override
  Future<void> close() async {
    await eventBusSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadWalletData(OnLoadWalletData event, Emitter<WalletState> emit) async {
    final activeRecoveries = await GetActiveRecoveryUseCase().run(accountService.currentAccount.address);
    emit(ActiveRecoveryStateMapper().mapResultToState(state, activeRecoveries));
  }

  Future<void> _onConnectionEvent(OnConnectionEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(errorMessage: event.isConnected ? null : "Disconnected"));
  }
}
