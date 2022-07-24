part of 'select_guardians_bloc.dart';

abstract class SelectGuardiansEvent extends Equatable {
  const SelectGuardiansEvent();

  @override
  List<Object?> get props => [];
}

class OnKeyChanged extends SelectGuardiansEvent {
  final String value;

  const OnKeyChanged(this.value);

  @override
  String toString() => 'OnKeyChanged: { OnKeyChanged: $value }';
}

class OnNameChanged extends SelectGuardiansEvent {
  final String value;

  const OnNameChanged(this.value);

  @override
  String toString() => 'OnNameChanged: { OnNameChanged: $value }';
}

class ClearPageCommand extends SelectGuardiansEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
