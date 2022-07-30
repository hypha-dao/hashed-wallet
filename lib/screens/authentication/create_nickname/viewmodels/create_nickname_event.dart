part of 'create_nickname_bloc.dart';

abstract class CreateNicknameEvent extends Equatable {
  const CreateNicknameEvent();

  @override
  List<Object?> get props => [];
}

class OnNicknameChange extends CreateNicknameEvent {
  final String nickname;

  const OnNicknameChange({required this.nickname});

  @override
  String toString() => 'OnNicknameChange: { nickname: $nickname }';
}

class OnNextTapped extends CreateNicknameEvent {
  const OnNextTapped();

  @override
  String toString() => 'OnNextTapped';
}
