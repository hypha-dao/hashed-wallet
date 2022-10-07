part of 'recover_account_overview_bloc.dart';

class RecoverAccountOverviewState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final ActiveRecoveryModel activeRecovery;
  final List<String> recoveredAccounts;

  const RecoverAccountOverviewState({
    required this.pageState,
    this.pageCommand,
    required this.activeRecovery,
    this.recoveredAccounts = const [],
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        activeRecovery,
        recoveredAccounts,
      ];

  RecoverAccountOverviewState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    ActiveRecoveryModel? activeRecovery,
    List<String>? recoveredAccounts,
  }) {
    return RecoverAccountOverviewState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      activeRecovery: activeRecovery ?? this.activeRecovery,
      recoveredAccounts: recoveredAccounts ?? this.recoveredAccounts,
    );
  }

  factory RecoverAccountOverviewState.initial() {
    return RecoverAccountOverviewState(
      pageState: PageState.initial,
      activeRecovery: ActiveRecoveryModel.empty,
    );
  }
}
