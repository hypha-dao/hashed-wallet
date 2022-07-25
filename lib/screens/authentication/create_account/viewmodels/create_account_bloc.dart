import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'create_account_events.dart';

part 'create_account_state.dart';

const nameMaxChars = 42;

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc() : super(CreateAccountState.initial()) {
    on<OnCreateNameNext>(_onCreateNameNext);
    on<ClearPageCommand>((event, emit) => emit(state.copyWith()));
  }

  void _onCreateNameNext(OnCreateNameNext event, Emitter<CreateAccountState> emit) {
    emit(state.copyWith( currentScreen: CreateAccountScreens.mnemonicSeed));
  }
}
