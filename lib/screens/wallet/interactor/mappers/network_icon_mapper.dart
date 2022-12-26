import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewdata/network_data.dart';
import 'package:hashed/screens/wallet/interactor/viewmodels/wallet_bloc.dart';

class NetworkIconMapper extends StateMapper {
  WalletState mapResultToState(WalletState currentState, NetworkData network) {
    return currentState.copyWith(
      pageState: PageState.success,
      logoUrl: network.iconUrl,
    );
  }
}
