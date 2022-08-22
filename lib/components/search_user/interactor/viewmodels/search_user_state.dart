part of 'search_user_bloc.dart';

class SearchUserState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final Account? account;
  final bool showClearIcon;

  bool get hasName => account?.name != null && account!.name!.isNotEmpty;
  String get name => account!.name!;

  const SearchUserState({
    required this.pageState,
    this.errorMessage,
    this.account,
    required this.showClearIcon,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        account,
        showClearIcon,
      ];

  SearchUserState copyWith({
    PageState? pageState,
    String? errorMessage,
    Account? account,
    bool? showClearIcon,
  }) {
    return SearchUserState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      account: account ?? this.account,
      showClearIcon: showClearIcon ?? this.showClearIcon,
    );
  }

  factory SearchUserState.initial() {
    return const SearchUserState(
      pageState: PageState.initial,
      showClearIcon: false,
    );
  }
}
