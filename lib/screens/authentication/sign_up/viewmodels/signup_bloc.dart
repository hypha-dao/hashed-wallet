import 'dart:async';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/generate_random_key_and_words_use_case.dart';
import 'package:seeds/screens/authentication/sign_up/mappers/create_account_state_mapper.dart';
import 'package:seeds/screens/authentication/sign_up/signup_errors.dart';
import 'package:seeds/screens/authentication/sign_up/usecases/create_account_usecase.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/page_commands.dart';
import 'package:seeds/utils/string_extension.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState.initial()) {
    on<DisplayNameOnNextTapped>(_displayNameOnNextTapped);
    on<OnCreateAccountTapped>(_onCreateAccountTapped);
    on<OnBackPressed>(_onBackPressed);
    on<ClearSignupPageCommand>((_, emit) => emit(state.copyWith()));
  }

  // if it has a invite deep link

  void _displayNameOnNextTapped(DisplayNameOnNextTapped event, Emitter<SignupState> emit) {
    emit(state.copyWith(signupScreens: SignupScreens.createAccount, displayName: event.displayName));
  }

  Future<void> _onCreateAccountTapped(OnCreateAccountTapped event, Emitter<SignupState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final words = await PolkadotRepository().createKey();
    print("secret words: $words");
    final AuthDataModel authData = AuthDataModel.fromString(words);
    emit(state.copyWith(auth: authData, pageState: PageState.success));
  }

  void _onBackPressed(OnBackPressed event, Emitter<SignupState> emit) {
    switch (state.signupScreens) {
      case SignupScreens.displayName:
        emit(state.copyWith(pageCommand: ReturnToLogin()));
        break;
      case SignupScreens.createAccount:
        emit(state.copyWith(signupScreens: SignupScreens.displayName));
        break;
    }
  }
}
