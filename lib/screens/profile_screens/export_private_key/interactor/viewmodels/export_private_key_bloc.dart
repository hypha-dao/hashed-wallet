import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/export_private_key/interactor/viewmodels/export_private_key_page_commands.dart';

part 'export_private_key_events.dart';

part 'export_private_key_state.dart';

const nameMaxChars = 42;

class ExportPrivateKeyBloc extends Bloc<ExportPrivateKeyEvent, ExportPrivateKeyState> {
  ExportPrivateKeyBloc() : super(ExportPrivateKeyState.initial()) {
    on<LoadSecretWords>(_loadSecretWords);
    on<OnExportButtonTapped>(_onExportButtonTapped);
    on<ClearPageCommand>((event, emit) => emit(state.copyWith()));
  }

  Future<void> _loadSecretWords(LoadSecretWords event, Emitter<ExportPrivateKeyState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final String? words = await accountService.getCurrentPrivateKey();
    if (words != null) {
      emit(state.copyWith(privateWords: words, pageState: PageState.success));
    } else {
      emit(state.copyWith(privateWords: words, pageState: PageState.success));
    }
  }

  void _onExportButtonTapped(OnExportButtonTapped event, Emitter<ExportPrivateKeyState> emit) {
    emit(state.copyWith(pageCommand: ShowSharePrivateKey()));
  }
}
