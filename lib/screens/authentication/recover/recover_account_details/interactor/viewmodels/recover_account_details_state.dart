part of 'recover_account_details_bloc.dart';

class RecoverAccountDetailsState extends Equatable {
  final PageState pageState;
  final String lostAccount;
  final PageCommand? pageCommand;
  final Uri? linkToActivateGuardians;
  final int totalGuardiansCount;
  final int threshold;
  final List<String> approvedAccounts;
  final List<String> guardianAccounts;

  List<String> get pendingAccounts => guardianAccounts.where((item) => !approvedAccounts.contains(item)).toList();

  const RecoverAccountDetailsState({
    required this.pageState,
    required this.lostAccount,
    this.pageCommand,
    required this.approvedAccounts,
    required this.guardianAccounts,
    this.linkToActivateGuardians,
    required this.totalGuardiansCount,
    required this.threshold,
  });

  @override
  List<Object?> get props => [
        pageState,
        lostAccount,
        pageCommand,
        linkToActivateGuardians,
        totalGuardiansCount,
        approvedAccounts,
        guardianAccounts,
        threshold,
      ];

  RecoverAccountDetailsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    Uri? linkToActivateGuardians,
    int? totalGuardiansCount,
    List<String>? approvedAccounts,
    List<String>? guardianAccounts,
    int? threshold,
  }) {
    return RecoverAccountDetailsState(
      pageState: pageState ?? this.pageState,
      lostAccount: lostAccount,
      pageCommand: pageCommand,
      approvedAccounts: approvedAccounts ?? this.approvedAccounts,
      guardianAccounts: guardianAccounts ?? this.guardianAccounts,
      totalGuardiansCount: totalGuardiansCount ?? this.totalGuardiansCount,
      linkToActivateGuardians: linkToActivateGuardians ?? this.linkToActivateGuardians,
      threshold: threshold ?? this.threshold,
    );
  }

  factory RecoverAccountDetailsState.initial(String userAccount) {
    return RecoverAccountDetailsState(
      pageState: PageState.initial,
      lostAccount: userAccount,
      totalGuardiansCount: 0,
      approvedAccounts: [],
      guardianAccounts: [],
      threshold: 0,
    );
  }
}
