part of 'export_private_key_bloc.dart';

class ExportPrivateKeyState extends Equatable {
  final PageState pageState;
  final String privateWords;
  final PageCommand? pageCommand;

  const ExportPrivateKeyState({
    required this.pageState,
    required this.privateWords,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        privateWords,
        pageCommand,
      ];

  ExportPrivateKeyState copyWith({
    PageState? pageState,
    String? privateWords,
    PageCommand? pageCommand,
  }) {
    return ExportPrivateKeyState(
      pageState: pageState ?? this.pageState,
      privateWords: privateWords ?? this.privateWords,
      pageCommand: pageCommand,
    );
  }

  factory ExportPrivateKeyState.initial() {
    return const ExportPrivateKeyState(
      privateWords: "Loading",
      pageState: PageState.initial,
    );
  }
}
