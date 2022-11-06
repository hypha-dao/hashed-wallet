part of 'scan_confirmation_bloc.dart';

abstract class ScanConfirmationEvent extends Equatable {
  const ScanConfirmationEvent();

  @override
  List<Object?> get props => [];
}

class ClearPageCommand extends ScanConfirmationEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}

class Initial extends ScanConfirmationEvent {
  const Initial();

  @override
  String toString() => 'Initial';
}

class OnSendTapped extends ScanConfirmationEvent {
  const OnSendTapped();

  @override
  String toString() => 'OnSendTapped';
}
