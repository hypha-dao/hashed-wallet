class NetworkData {
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
