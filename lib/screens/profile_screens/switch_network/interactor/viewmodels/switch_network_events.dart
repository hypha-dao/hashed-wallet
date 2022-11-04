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

class OnNetworkSelected extends SwitchNetworkEvent {
  final NetworkData networkData;

  const OnNetworkSelected(this.networkData);

  @override
  String toString() => 'OnNetworkSelected';
}

class OnSearchChanged extends SwitchNetworkEvent {
  final String value;

  const OnSearchChanged(this.value);

  @override
  String toString() => 'OnSearchChanged';
}
