import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'select_guardians_event.dart';
part 'select_guardians_state.dart';

class SelectGuardiansBloc extends Bloc<SelectGuardiansEvent, SelectGuardiansState> {
  SelectGuardiansBloc(List<GuardianModel> myGuardians) : super(SelectGuardiansState.initial(myGuardians)) {
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }
}
