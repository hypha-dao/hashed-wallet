part of 'guardians_bloc.dart';

abstract class GuardiansEvent extends Equatable {
  const GuardiansEvent();

  @override
  List<Object?> get props => [];
}

class InitGuardians extends GuardiansEvent {
  final Iterable<GuardianModel> myGuardians;

  const InitGuardians(this.myGuardians);

  @override
  String toString() => 'InitGuardians: { myGuardians: $myGuardians }';
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
  final GuardianModel guardian;

  const OnRemoveGuardianTapped(this.guardian);

  @override
  String toString() => 'OnRemoveGuardianTapped : { guardian: $guardian }';
}

class Initial extends GuardiansEvent {
  @override
  String toString() => 'Initial';
}

class OnGuardianReadyForActivation extends GuardiansEvent {
  final Iterable<GuardianModel> myGuardians;

  const OnGuardianReadyForActivation(this.myGuardians);

  @override
  String toString() => 'OnGuardianReadyForActivation: { myGuardians: $myGuardians }';
}
