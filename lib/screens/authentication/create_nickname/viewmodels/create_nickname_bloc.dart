import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_nickname_event.dart';

part 'create_nickname_state.dart';

class CreateNicknameBloc extends Bloc<CreateNicknameEvent, CreateNicknameState> {
  CreateNicknameBloc() : super(CreateNicknameState.initial()) {
    on<OnNicknameChange>((event, emit) => emit(state.copyWith(nickname: event.nickname)));
    on<OnNextTapped>((event, emit) => emit(state.copyWith(continueToAccount: true, isButtonLoading: true)));
  }
}
