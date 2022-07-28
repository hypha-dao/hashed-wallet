part of 'create_nickname_bloc.dart';

class CreateNicknameState extends Equatable {
  final String? nickname;
  final bool continueToAccount;
  final bool isButtonLoading;

  const CreateNicknameState({
    this.nickname,
    required this.continueToAccount,
    required this.isButtonLoading,
  });

  @override
  List<Object?> get props => [
        nickname,
        continueToAccount,
        isButtonLoading,
      ];

  CreateNicknameState copyWith({
    String? nickname,
    bool? continueToAccount,
    bool? isButtonLoading,
  }) {
    return CreateNicknameState(
      nickname: nickname ?? this.nickname,
      continueToAccount: continueToAccount ?? this.continueToAccount,
      isButtonLoading: isButtonLoading ?? this.isButtonLoading,
    );
  }

  factory CreateNicknameState.initial() {
    return const CreateNicknameState(
      continueToAccount: false,
      isButtonLoading: false,
    );
  }
}
