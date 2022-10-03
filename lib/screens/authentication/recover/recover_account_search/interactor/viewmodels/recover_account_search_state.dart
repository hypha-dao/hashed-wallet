part of 'recover_account_search_bloc.dart';

class RecoverAccountSearchState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final String? account;
  final bool isNextEnabled;
  final bool isNextLoading;

  const RecoverAccountSearchState({
    this.pageCommand,
    required this.pageState,
    required this.account,
    required this.isNextEnabled,
    required this.isNextLoading,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        account,
        isNextEnabled,
        isNextLoading,
      ];

  RecoverAccountSearchState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    String? account,
    bool? isNextEnabled,
    bool? isNextLoading,
  }) {
    return RecoverAccountSearchState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      account: account ?? this.account,
      isNextEnabled: isNextEnabled ?? this.isNextEnabled,
      isNextLoading: isNextLoading ?? this.isNextLoading,
    );
  }

  factory RecoverAccountSearchState.initial() {
    return const RecoverAccountSearchState(
      pageState: PageState.initial,
      account: null,
      isNextEnabled: false,
      isNextLoading: false,
    );
  }
}
