part of 'guardians_bloc.dart';

abstract class GuardiansEvent extends Equatable {
  const GuardiansEvent();

  @override
  List<Object?> get props => [];
}

class ClearPageCommand extends GuardiansEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}

class OnStopRecoveryForUser extends GuardiansEvent {
  @override
  String toString() => 'OnStopRecoveryForUser';
}

class OnRemoveGuardianTapped extends GuardiansEvent {
  final Account guardian;

  const OnRemoveGuardianTapped(this.guardian);

  @override
  String toString() => 'OnRemoveGuardianTapped : { guardian: $guardian }';
}

class OnGuardianAdded extends GuardiansEvent {
  final Account account;

  const OnGuardianAdded(this.account);

  @override
  String toString() => 'OnGuardianAdded : { OnGuardianAdded: $account }';
}

class Initial extends GuardiansEvent {
  @override
  String toString() => 'Initial';
}

class ActivateGuardians extends GuardiansEvent {
  @override
  String toString() => 'ActivateGuardians';
}

class OnResetConfirmed extends GuardiansEvent {
  @override
  String toString() => 'OnResetConfirmed';
}

class OnActivateConfirmed extends GuardiansEvent {
  @override
  String toString() => 'OnActivateConfirmed';
}

class OnMyGuardianActionButtonTapped extends GuardiansEvent {
  @override
  String toString() => 'OnMyGuardianActionButtonTapped';
}
