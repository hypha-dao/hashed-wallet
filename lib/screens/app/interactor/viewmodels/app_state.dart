part of 'app_bloc.dart';

class AppState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final int index;
  final bool hasNotification;
  final bool showGuardianRecoveryAlert;
  final List<ActiveRecoveryModel>? activeRecoveries;
  final GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen;

  const AppState({
    required this.pageState,
    this.pageCommand,
    required this.index,
    required this.hasNotification,
    required this.showGuardianRecoveryAlert,
    required this.showGuardianApproveOrDenyScreen,
    this.activeRecoveries,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        index,
        hasNotification,
        showGuardianRecoveryAlert,
        showGuardianApproveOrDenyScreen,
        activeRecoveries,
      ];

  AppState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    int? index,
    bool? hasNotification,
    bool? showGuardianRecoveryAlert,
    GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen,
    List<ActiveRecoveryModel>? activeRecoveries,
  }) {
    return AppState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      index: index ?? this.index,
      hasNotification: hasNotification ?? this.hasNotification,
      showGuardianRecoveryAlert: showGuardianRecoveryAlert ?? this.showGuardianRecoveryAlert,
      showGuardianApproveOrDenyScreen: showGuardianApproveOrDenyScreen,
      activeRecoveries: activeRecoveries ?? this.activeRecoveries,
    );
  }

  factory AppState.initial(GuardianRecoveryRequestData? showGuardianApproveOrDenyScreen) {
    return AppState(
      pageState: PageState.loading,
      index: 0,
      hasNotification: false,
      showGuardianRecoveryAlert: false,
      showGuardianApproveOrDenyScreen: showGuardianApproveOrDenyScreen,
    );
  }
}
