import 'package:collection/collection.dart';

abstract class NetworkDataListItem {
  const NetworkDataListItem();
}

class NetworkDataHeader extends NetworkDataListItem {
  final String header;

  NetworkDataHeader(this.header);
}

class NetworkData extends NetworkDataListItem {
  final String name;
  final String info;
  final String iconUrl;
  final int? paraChainId;
  final List<Uri> endpoints;

  Uri get uri => endpoints.first;
  bool get isRelayChain => paraChainId == null;

  const NetworkData({
    required this.name,
    required this.info,
    required this.iconUrl,
    this.paraChainId,
    required this.endpoints,
  });
}

extension ListItems on List<NetworkDataListItem> {
  NetworkData? itemById(String id) {
    return firstWhereOrNull(
      (e) => e is NetworkData && e.info == id,
    ) as NetworkData?;
  }
}
