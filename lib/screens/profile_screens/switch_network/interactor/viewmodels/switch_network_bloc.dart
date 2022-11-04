import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewdata/network_data.dart';

part 'switch_network_events.dart';
part 'switch_network_state.dart';

final mockData = [
  NetworkData('Polkadot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('KakaDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('PopoDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
];

class SwitchNetworkBloc extends Bloc<SwitchNetworkEvent, SwitchNetworkState> {
  SwitchNetworkBloc() : super(SwitchNetworkState.initial()) {
    on<Initial>(_initial);
    on<OnNetworkSelected>(_onNetworkSelected);
    on<OnSearchChanged>(_onSearchChanged);
  }

  Future<void> _initial(Initial event, Emitter<SwitchNetworkState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<List<NetworkData>> result = await Future.value(Result.value(mockData));
    if (result.isValue) {
      emit(state.copyWith(data: result.asValue!.value, pageState: PageState.success, filtered: result.asValue!.value));
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onNetworkSelected(OnNetworkSelected event, Emitter<SwitchNetworkState> emit) {
    emit(state.copyWith(selected: event.networkData));
  }

  FutureOr<void> _onSearchChanged(OnSearchChanged event, Emitter<SwitchNetworkState> emit) {
    emit(state.copyWith(
        filtered: state.data
            .where((element) => element.name.toLowerCase().contains(
                  event.value.toLowerCase(),
                ))
            .toList()));
  }
}
