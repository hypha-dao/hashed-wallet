import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/mappers/update_profile_state_mapper.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/usecases/update_profile_use_case.dart';

part 'edit_name_event.dart';

part 'edit_name_state.dart';

const nameMaxChars = 42;

class EditNameBloc extends Bloc<EditNameEvent, EditNameState> {
  EditNameBloc(ProfileModel profileModel) : super(EditNameState.initial(profileModel)) {
    on<OnNameChanged>(_onNameChange);
    on<SubmitName>(_submitName);
    on<ClearPageCommand>((event, emit) => emit(state.copyWith()));
  }

  Future<void> _submitName(SubmitName event, Emitter<EditNameState> emit) async {
    if (state.profileModel.nickname != state.name) {
      emit(state.copyWith(pageState: PageState.loading));
      final result = await UpdateProfileUseCase().run(newName: state.name, profile: state.profileModel);
      emit(UpdateProfileStateMapper().mapResultToState(state, result));
    }
  }

  FutureOr<void> _onNameChange(OnNameChanged event, Emitter<EditNameState> emit) {
    emit(state.copyWith(name: event.name));
    if (event.name.length > nameMaxChars) {
      emit(state.copyWith(errorMessage: "Max length is $nameMaxChars characters"));
    } else if (event.name.isEmpty) {
      emit(state.copyWith(errorMessage: "Name cannot be empty"));
    }
  }
}
