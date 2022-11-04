part of 'switch_network_bloc.dart';

class SwitchNetworkState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;

  const SwitchNetworkState({
    required this.pageState,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
      ];

  SwitchNetworkState copyWith({
    PageState? pageState,
    String? privateWords,
    PageCommand? pageCommand,
  }) {
    return SwitchNetworkState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
    );
  }

  factory SwitchNetworkState.initial() {
    return const SwitchNetworkState(
      pageState: PageState.initial,
    );
  }
}
