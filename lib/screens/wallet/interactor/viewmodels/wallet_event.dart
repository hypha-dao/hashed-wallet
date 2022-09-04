part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class OnLoadWalletData extends WalletEvent {
  const OnLoadWalletData();

  @override
  String toString() => 'OnLoadWalletData';
}

class OnConnectionEvent extends WalletEvent {
  final bool isConnected;
  const OnConnectionEvent(this.isConnected);

  @override
  String toString() => 'OnConnectionEvent';
}
