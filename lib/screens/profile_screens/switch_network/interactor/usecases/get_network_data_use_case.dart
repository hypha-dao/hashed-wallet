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
    return Future.delayed(const Duration(milliseconds: 300)).then((value) => Result.value(mockData));
  }
}
