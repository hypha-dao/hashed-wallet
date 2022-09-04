import 'package:hashed/components/snack.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';
import 'package:meta/meta.dart';

/// --- EVENT BUS EVENTS
///
@immutable
abstract class BusEvent<T> {
  const BusEvent();
  @override
  String toString() => 'EventBus { $T }';
}

class OnNewTransactionEventBus extends BusEvent<OnNewTransactionEventBus> {
  final SendTransaction? transactionModel;
  const OnNewTransactionEventBus(this.transactionModel);
}

class OnFiatCurrencyChangedEventBus extends BusEvent<OnNewTransactionEventBus> {
  const OnFiatCurrencyChangedEventBus();
}

class OnWalletRefreshEventBus extends BusEvent<OnWalletRefreshEventBus> {
  const OnWalletRefreshEventBus();
}

class OnConnectionStateEventBus extends BusEvent<OnConnectionStateEventBus> {
  final bool connected;
  const OnConnectionStateEventBus(this.connected);
}

class ShowSnackBar extends BusEvent<OnNewTransactionEventBus> {
  final String message;
  final SnackType snackType;

  const ShowSnackBar(this.message) : snackType = SnackType.info;
  const ShowSnackBar.success(this.message) : snackType = SnackType.success;
  const ShowSnackBar.failure(this.message) : snackType = SnackType.failure;
}
