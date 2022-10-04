part of 'recover_account_success_bloc.dart';

class RecoverAccountSuccessState extends Equatable {
  final PageState pageState;
  final String lostAccount;
  final TokenDataModel recoverAmount;
  final PageCommand? pageCommand;

  const RecoverAccountSuccessState({
    required this.pageState,
    required this.lostAccount,
    this.pageCommand,
    required this.recoverAmount,
  });

  @override
  List<Object?> get props => [
        pageState,
        lostAccount,
        pageCommand,
        recoverAmount,
      ];

  RecoverAccountSuccessState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    TokenDataModel? recoverAmount,
  }) {
    return RecoverAccountSuccessState(
      pageState: pageState ?? this.pageState,
      lostAccount: lostAccount,
      pageCommand: pageCommand,
      recoverAmount: recoverAmount ?? this.recoverAmount,
    );
  }

  factory RecoverAccountSuccessState.initial(String lostAccount) {
    return RecoverAccountSuccessState(
        pageState: PageState.initial, lostAccount: lostAccount, recoverAmount: TokenDataModel(0));
  }
}
