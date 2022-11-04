part of 'switch_network_bloc.dart';

abstract class SwitchNetworkEvent extends Equatable {
  const SwitchNetworkEvent();

  @override
  List<Object?> get props => [];
}

class Initial extends SwitchNetworkEvent {
  const Initial();

  @override
  String toString() => 'Initial';
}
