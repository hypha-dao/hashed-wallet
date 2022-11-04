part of 'switch_network_bloc.dart';

class SwitchNetworkState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final List<NetworkData> data;
  final List<NetworkData> filtered;
  final NetworkData? selected;

  const SwitchNetworkState({
    required this.pageState,
    this.pageCommand,
    required this.data,
    this.selected,
    required this.filtered,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        data,
        selected,
        filtered,
      ];

  SwitchNetworkState copyWith({
    PageState? pageState,
    List<NetworkData>? data,
    List<NetworkData>? filtered,
    PageCommand? pageCommand,
    NetworkData? selected,
  }) {
    return SwitchNetworkState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      data: data ?? this.data,
      selected: selected ?? this.selected,
      filtered: filtered ?? this.filtered,
    );
  }

  factory SwitchNetworkState.initial() {
    return const SwitchNetworkState(
      pageState: PageState.initial,
      data: [],
      filtered: [],
    );
  }
}
