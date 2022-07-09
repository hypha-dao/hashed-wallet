part of 'vote_bloc.dart';

class VoteState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final int cycleEndTimestamp;
  final CurrentRemainingTime? currentRemainingTime;
  final bool shouldShowDelegateIcon;
  final bool isCitizen;
  final List<CategoryDelegate> currentDelegates;
  final bool voteCycleHasEnded;

  const VoteState({
    required this.pageState,
    this.errorMessage,
    required this.cycleEndTimestamp,
    this.currentRemainingTime,
    required this.shouldShowDelegateIcon,
    required this.isCitizen,
    required this.currentDelegates,
    required this.voteCycleHasEnded,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        cycleEndTimestamp,
        currentRemainingTime,
        shouldShowDelegateIcon,
        isCitizen,
        currentDelegates,
        voteCycleHasEnded,
      ];

  VoteState copyWith({
    PageState? pageState,
    String? errorMessage,
    int? cycleEndTimestamp,
    CurrentRemainingTime? currentRemainingTime,
    bool? shouldShowDelegateIcon,
    bool? isCitizen,
    List<CategoryDelegate>? currentDelegates,
    bool? voteCycleHasEnded,
  }) {
    return VoteState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      cycleEndTimestamp: cycleEndTimestamp ?? this.cycleEndTimestamp,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
      shouldShowDelegateIcon: shouldShowDelegateIcon ?? this.shouldShowDelegateIcon,
      isCitizen: isCitizen ?? this.isCitizen,
      currentDelegates: currentDelegates ?? this.currentDelegates,
      voteCycleHasEnded: voteCycleHasEnded ?? this.voteCycleHasEnded,
    );
  }

  factory VoteState.initial(bool featureFlagDelegateEnabled, bool isCitizen) {
    return VoteState(
      pageState: PageState.initial,
      cycleEndTimestamp: 0,
      shouldShowDelegateIcon: featureFlagDelegateEnabled,
      isCitizen: isCitizen,
      currentDelegates: [],
      voteCycleHasEnded: false,
    );
  }
}
