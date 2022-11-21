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
  NetworkData('P1poDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('Po2oDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('3opoDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('4opoDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('5opoDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('6opoDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('Po7oDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('Popo8ot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('Po9oDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('Po0oDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('P12poDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('P13poDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('P14poDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('Po14oDot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
  NetworkData('Pop14Dot', 'https://picsum.photos/40', 'http://ThisisPokaDot.com'),
];

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

    // TODO(NIK): here is where you make the calls to fetch all networks. Inside a use case
    final Result<List<NetworkData>> result =
        await Future.delayed(const Duration(seconds: 2)).then((value) => Result.value(mockData));
    if (result.isValue) {
      emit(state.copyWith(
        data: result.asValue!.value,
        pageState: PageState.success,
        filtered: result.asValue!.value,
        // TODO(NIK): this needs to be changed to select the actual currently selected network
        selected: result.asValue!.value.first,
      ));
    } else {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  FutureOr<void> _onNetworkSelected(OnNetworkSelected event, Emitter<SwitchNetworkState> emit) {
    emit(state.copyWith(selected: event.networkData, actionButtonEnabled: true));
  }

  FutureOr<void> _onSearchChanged(OnSearchChanged event, Emitter<SwitchNetworkState> emit) {
    emit(state.copyWith(
        filtered: state.data
            .where((element) => element.name.toLowerCase().contains(
                  event.value.toLowerCase(),
                ))
            .toList()));
  }

  FutureOr<void> _onSwitchTapped(OnSwitchTapped event, Emitter<SwitchNetworkState> emit) async {
    emit(state.copyWith(actionButtonLoading: true));

    // TODO(NIK): here is where you make the calls to switch the network. Inside a use case
    final Result<bool> result = await Future.delayed(const Duration(seconds: 2)).then((value) => Result.value(true));
    if (result.isValue) {
      emit(state.copyWith(
        actionButtonLoading: false,
        pageCommand: ShowMessage('Network Switched to ${state.selected!.name}'),
      ));
    } else {
      emit(state.copyWith(
        actionButtonLoading: false,
        pageCommand: ShowErrorMessage('Error Switching networks'),
      ));
    }
  }
}
