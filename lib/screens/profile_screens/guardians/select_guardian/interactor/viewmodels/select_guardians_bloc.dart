import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/utils/string_extension.dart';

part 'select_guardians_event.dart';
part 'select_guardians_state.dart';

class SelectGuardiansBloc extends Bloc<SelectGuardiansEvent, SelectGuardiansState> {
  SelectGuardiansBloc() : super(SelectGuardiansState.initial()) {
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
    on<OnKeyChanged>(_onKeyChanged);
    on<OnNameChanged>(_onNameChanged);
  }

  FutureOr<void> _onKeyChanged(OnKeyChanged event, Emitter<SelectGuardiansState> emit) {
    emit(state.copyWith(guardianKey: event.value));
  }

  FutureOr<void> _onNameChanged(OnNameChanged event, Emitter<SelectGuardiansState> emit) {
    emit(state.copyWith(guardianName: event.value));
  }
}
