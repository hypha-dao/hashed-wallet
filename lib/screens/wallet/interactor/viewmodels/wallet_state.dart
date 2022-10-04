part of 'wallet_bloc.dart';

class WalletState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final ProfileModel profile;
  final List<ActiveRecoveryModel>? activeRecoveries;

  const WalletState({
    required this.pageState,
    this.pageCommand,
    required this.profile,
    this.errorMessage,
    this.activeRecoveries,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        profile,
        activeRecoveries,
      ];

  WalletState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    ProfileModel? profile,
    List<ActiveRecoveryModel>? activeRecoveries,
  }) {
    return WalletState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand ?? this.pageCommand,
      errorMessage: errorMessage,
      profile: profile ?? this.profile,
      activeRecoveries: activeRecoveries ?? this.activeRecoveries,
    );
  }

  factory WalletState.initial() {
    return WalletState(
      pageState: PageState.initial,
      profile: ProfileModel(
        account: accountService.currentAccount.address,
        status: ProfileStatus.visitor,
        type: '',
        nickname: '',
        image: '',
        story: '',
        roles: '',
        skills: '',
        interests: '',
        reputation: 0,
        timestamp: 0,
      ),
    );
  }
}
