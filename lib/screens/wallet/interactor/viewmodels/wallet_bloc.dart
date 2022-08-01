import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState.initial()) {
    on<OnLoadWalletData>(_onLoadWalletData);
  }

  Future<void> _onLoadWalletData(OnLoadWalletData event, Emitter<WalletState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    // final result = await LoadTokenBalancesUseCase().run(TokenModel.allTokens);
    // emit(UserAccountStateMapper().mapResultToState(state, result));
  }
}
