part of 'recover_account_details_bloc.dart';

class RecoverAccountDetailsState extends Equatable {
  final PageState pageState;
  final String userAccount;
  final PageCommand? pageCommand;
  final Uri? linkToActivateGuardians;
  final int totalGuardiansCount;
  final List<String> approvedAccounts;

  const RecoverAccountDetailsState({
    required this.pageState,
    required this.userAccount,
    this.pageCommand,
    required this.approvedAccounts,
    this.linkToActivateGuardians,
    required this.totalGuardiansCount,
  });

  @override
  List<Object?> get props => [
        pageState,
        userAccount,
        pageCommand,
        linkToActivateGuardians,
        totalGuardiansCount,
        approvedAccounts,
      ];

  RecoverAccountDetailsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    Uri? linkToActivateGuardians,
    int? totalGuardiansCount,
    List<String>? approvedAccount,
  }) {
    return RecoverAccountDetailsState(
      pageState: pageState ?? this.pageState,
      userAccount: userAccount,
      pageCommand: pageCommand,
      approvedAccounts: approvedAccount ?? this.approvedAccounts,
      totalGuardiansCount: totalGuardiansCount ?? this.totalGuardiansCount,
      linkToActivateGuardians: linkToActivateGuardians ?? this.linkToActivateGuardians,
    );
  }

  factory RecoverAccountDetailsState.initial(String userAccount) {
    return RecoverAccountDetailsState(
        pageState: PageState.initial,
        userAccount: userAccount,
        totalGuardiansCount: 3,
        approvedAccounts: ['87665432', '1232456']);
  }
}
