import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/usecases/get_network_data_use_case.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/usecases/switch_network_use_case.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewdata/network_data.dart';
part 'switch_network_events.dart';
part 'switch_network_state.dart';

class SwitchNetworkBloc extends Bloc<SwitchNetworkEvent, SwitchNetworkState> {
  SwitchNetworkBloc() : super(SwitchNetworkState.initial()) {
    on<Initial>(_initial);
    on<OnSwitchTapped>(_onSwitchTapped);
    on<OnNetworkSelected>(_onNetworkSelected);
    on<OnSearchChanged>(_onSearchChanged);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _initial(Initial event, Emitter<SwitchNetworkState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));

    final Result<List<NetworkDataListItem>> result = await GetNetworkDataUseCase().run();

    if (result.isValue) {
      emit(state.copyWith(
        data: result.asValue!.value,
        pageState: PageState.success,
        filtered: result.asValue!.value,
        selected: result.asValue!.value.itemById(settingsStorage.currentNetwork),
      ));
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onNetworkSelected(OnNetworkSelected event, Emitter<SwitchNetworkState> emit) {
    emit(state.copyWith(
        selected: event.networkData, actionButtonEnabled: event.networkData.info != settingsStorage.currentNetwork));
  }

  FutureOr<void> _onSearchChanged(OnSearchChanged event, Emitter<SwitchNetworkState> emit) {
    emit(state.copyWith(
        filtered: state.data
            // ignore: avoid_bool_literals_in_conditional_expressions
            .where((element) => element is NetworkData
                ? element.name.toLowerCase().contains(event.value.toLowerCase())
                : element is NetworkDataHeader)
            .toList()));
  }

  FutureOr<void> _onSwitchTapped(OnSwitchTapped event, Emitter<SwitchNetworkState> emit) async {
    emit(state.copyWith(actionButtonLoading: true));

    final result = await SwitchNetworkUseCase().run(event.networkData);

    if (result.isValue) {
      settingsStorage.currentNetwork = event.networkData.info;
      emit(state.copyWith(
        actionButtonLoading: false,
        pageCommand: ShowMessage('Network Switched to ${event.networkData.name}'),
      ));
    } else {
      emit(state.copyWith(
        actionButtonLoading: false,
        pageCommand: ShowErrorMessage('Error Switching networks'),
      ));
    }
  }
}
