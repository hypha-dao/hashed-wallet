part of 'recover_account_success_bloc.dart';

class RecoverAccountSuccessState extends Equatable {
  final PageState pageState;
  final String userAccount;
  final double recoverAmount;
  final String recoveredAccount;
  final PageCommand? pageCommand;

  const RecoverAccountSuccessState({
    required this.pageState,
    required this.userAccount,
    this.pageCommand,
    required this.recoverAmount,
    required this.recoveredAccount,
  });

  @override
  List<Object?> get props => [
        pageState,
        userAccount,
        pageCommand,
        recoverAmount,
        recoveredAccount,
      ];

  RecoverAccountSuccessState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    double? recoverAmount,
    String? recoveredAccount,
  }) {
    return RecoverAccountSuccessState(
      pageState: pageState ?? this.pageState,
      userAccount: userAccount,
      pageCommand: pageCommand,
      recoverAmount: recoverAmount ?? this.recoverAmount,
      recoveredAccount: recoveredAccount ?? this.recoveredAccount,
    );
  }

  factory RecoverAccountSuccessState.initial(String userAccount) {
    return RecoverAccountSuccessState(
        pageState: PageState.initial, userAccount: userAccount, recoverAmount: 0, recoveredAccount: '');
  }
}
