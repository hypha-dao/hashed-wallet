part of 'wallet_bloc.dart';

class WalletState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final ProfileModel profile;
  final List<ActiveRecoveryModel>? activeRecoveries;
  final String logoUrl;

  const WalletState({
    required this.pageState,
    this.pageCommand,
    required this.profile,
    this.errorMessage,
    this.activeRecoveries,
    required this.logoUrl,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        profile,
        activeRecoveries,
        logoUrl,
      ];

  WalletState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    ProfileModel? profile,
    List<ActiveRecoveryModel>? activeRecoveries,
    String? logoUrl,
  }) {
    return WalletState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand ?? this.pageCommand,
      errorMessage: errorMessage,
      profile: profile ?? this.profile,
      activeRecoveries: activeRecoveries ?? this.activeRecoveries,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  factory WalletState.initial() {
    return WalletState(
      pageState: PageState.initial,
      logoUrl: hashedToken.logoUrl,
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
