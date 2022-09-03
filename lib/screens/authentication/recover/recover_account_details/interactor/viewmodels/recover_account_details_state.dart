part of 'recover_account_details_bloc.dart';

class RecoverAccountDetailsState extends Equatable {
  final PageState pageState;
  final String userAccount;
  final PageCommand? pageCommand;

  const RecoverAccountDetailsState({
    required this.pageState,
    required this.userAccount,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        userAccount,
        pageCommand,
      ];

  RecoverAccountDetailsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
  }) {
    return RecoverAccountDetailsState(
      pageState: pageState ?? this.pageState,
      userAccount: userAccount,
      pageCommand: pageCommand,
    );
  }

  factory RecoverAccountDetailsState.initial(String userAccount) {
    return RecoverAccountDetailsState(
      pageState: PageState.initial,
      userAccount: userAccount,
    );
  }
}
