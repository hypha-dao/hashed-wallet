import 'package:hashed/datasource/remote/polkadot_api/chains_repository.dart';
import 'package:hashed/domain-shared/app_constants.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewdata/network_data.dart';
import 'package:hashed/utils/result_extension.dart';

final mockData = [
  NetworkDataHeader("Polkadot"),
  NetworkData(
      name: 'Polkadot',
      info: "polkadot",
      iconUrl: 'https://picsum.photos/40',
      endpoints: [Uri.parse('http://ThisisPokaDot.com')]),
  NetworkData(
      name: 'Hashed Network',
      info: hashedNetworkId,
      iconUrl: 'https://picsum.photos/40',
      endpoints: [Uri.parse('http://ThisisPokaDot.com')]),
  NetworkData(
      name: 'KakaDot',
      info: "kakadot",
      iconUrl: 'https://picsum.photos/40',
      endpoints: [Uri.parse('http://ThisisPokaDot.com')]),
  NetworkDataHeader("Kusama"),
  NetworkData(
      name: 'FoobarDot',
      info: "foobardot",
      iconUrl: 'https://picsum.photos/40',
      endpoints: [Uri.parse('http://ThisisPokaDot.com')]),
];

class GetNetworkDataUseCase {
  Future<Result<List<NetworkDataListItem>>> run() async {
    final chainsRepository = ChainsRepository();
    final chainData = await chainsRepository.getChainsLocal();

    final List<NetworkDataListItem> list = [];

    final bool devMode = false;

    // TODO(NIK): Not sure this parsing and reformatting should take place here or in the repo
    // it's creating view data from the raw repo data.

    /// Add Hashed Chain
    list.add(NetworkDataHeader("Hashed"));
    list.add(
      NetworkData(
          name: 'Hashed Network',
          info: hashedNetworkId,
          iconUrl: '',
          endpoints: [Uri.parse('wss://n1.hashed.systems')]),
    );

    /// Add Polkadot, Kusama, and dev chains
    for (final chainContainer in chainData) {
      if (!devMode) {
        final name = chainContainer.header.toLowerCase();
        if (!chainContainer.isRelayChain || (name != "polkadot" && name != "kusama")) {
          print("not dev mode, skipping $name");
          continue;
        }
      }

      list.add(NetworkDataHeader(chainContainer.header));

      if (chainContainer.isRelayChain) {
        final chain = chainContainer.relayChain!;
        final icon = await chainsRepository.resolveIcon(chain.info);
        list.add(chain.toNetworkData(icon));

        for (final paraChain in chain.linked ?? []) {
          final icon = await chainsRepository.resolveIcon(paraChain.info);
          list.add(paraChain.toNetworkData(icon));
        }
      } else {
        for (final devChain in chainContainer.list ?? []) {
          final icon = await chainsRepository.resolveIcon(devChain.info);
          list.add(devChain.toNetworkData(icon));
        }
      }
    }

    return Future.delayed(const Duration(milliseconds: 300)).then((value) => Result.value(list));
  }
}
