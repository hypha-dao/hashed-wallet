import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewdata/network_data.dart';
import 'package:hashed/utils/result_extension.dart';

class SwitchNetworkUseCase {
  Future<Result<String>> run(NetworkData selected) async {
    if (settingsStorage.currentNetwork == selected.info) {
      return Result.value(selected.info);
    }

    try {
      final stopped = await polkadotRepository.stopService();

      await polkadotRepository.initService(selected);
      final connected = await polkadotRepository.startService();

      if (connected) {
        return Result.value(selected.info);
      } else {
        return Result.error("Unable to connect to ${selected.name} ${selected.endpoints}");
      }
    } catch (error) {
      return Result.error("Network switch failed $error");
    }
  }
}
