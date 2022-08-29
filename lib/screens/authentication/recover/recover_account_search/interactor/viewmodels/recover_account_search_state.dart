part of 'recover_account_search_bloc.dart';

class RecoverAccountSearchState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final String? account;
  final bool isNextEnabled;

  const RecoverAccountSearchState({
    this.pageCommand,
    required this.pageState,
    required this.account,
    required this.isNextEnabled,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        account,
        isNextEnabled,
      ];

  RecoverAccountSearchState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    String? account,
    bool? isNextEnabled,
  }) {
    return RecoverAccountSearchState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      account: account ?? this.account,
      isNextEnabled: isNextEnabled ?? this.isNextEnabled,
    );
  }

  factory RecoverAccountSearchState.initial() {
    return const RecoverAccountSearchState(
      pageState: PageState.initial,
      account: null,
      isNextEnabled: false,
    );
  }
}
