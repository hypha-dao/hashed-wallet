part of 'recover_account_success_bloc.dart';

class RecoverAccountSuccessState extends Equatable {
  final PageState pageState;
  final String lostAccount;
  final TokenDataModel recoverAmount;
  final PageCommand? pageCommand;
  final ActiveRecoveryModel activeRecoveryModel;
  final GuardiansConfigModel guardiansConfig;

  const RecoverAccountSuccessState({
    required this.pageState,
    required this.lostAccount,
    this.pageCommand,
    required this.recoverAmount,
    required this.activeRecoveryModel,
    required this.guardiansConfig,
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
    ActiveRecoveryModel? activeRecoveryModel,
    GuardiansConfigModel? guardiansConfig,
  }) {
    return RecoverAccountSuccessState(
      pageState: pageState ?? this.pageState,
      lostAccount: lostAccount,
      pageCommand: pageCommand,
      recoverAmount: recoverAmount ?? this.recoverAmount,
      activeRecoveryModel: activeRecoveryModel ?? this.activeRecoveryModel,
      guardiansConfig: guardiansConfig ?? this.guardiansConfig,
    );
  }

  factory RecoverAccountSuccessState.initial(String lostAccount) {
    return RecoverAccountSuccessState(
      pageState: PageState.initial,
      lostAccount: lostAccount,
      recoverAmount: TokenDataModel(0),
      guardiansConfig: GuardiansConfigModel.empty(),
      activeRecoveryModel: ActiveRecoveryModel.empty,
    );
  }
}
