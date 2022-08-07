part of 'export_private_key_bloc.dart';

abstract class ExportPrivateKeyEvent extends Equatable {
  const ExportPrivateKeyEvent();

  @override
  List<Object?> get props => [];
}

class LoadSecretWords extends ExportPrivateKeyEvent {
  const LoadSecretWords();

  @override
  String toString() => 'LoadSecretWords';
}

class OnExportButtonTapped extends ExportPrivateKeyEvent {
  const OnExportButtonTapped();

  @override
  String toString() => 'OnExportButtonTapped';
}

class ClearPageCommand extends ExportPrivateKeyEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
