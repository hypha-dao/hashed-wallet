import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/profile_screens/export_private_key/interactor/viewmodels/export_private_key_page_commands.dart';

part 'switch_network_events.dart';
part 'switch_network_state.dart';

const nameMaxChars = 42;

class SwitchNetworkBloc extends Bloc<SwitchNetworkEvent, SwitchNetworkState> {
  SwitchNetworkBloc() : super(SwitchNetworkState.initial()) {}

  // Future<void> _loadSecretWords(LoadSecretWords event, Emitter<ExportPrivateKeyState> emit) async {
  //   emit(state.copyWith(pageState: PageState.loading));
  //   final String? words = await accountService.getCurrentPrivateKey();
  //   if (words != null) {
  //     emit(state.copyWith(privateWords: words, pageState: PageState.success));
  //   } else {
  //     emit(state.copyWith(privateWords: words, pageState: PageState.success));
  //   }
  // }
}
