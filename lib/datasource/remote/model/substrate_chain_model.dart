import 'package:hashed/screens/profile_screens/switch_network/interactor/viewdata/network_data.dart';

class SubstrateChainModel {
  final String info;
  final String text;
  final int? paraId;
  Map<String, String> providers;
  final String? dnslink;
  final String? genesisHash;
  final List<int>? teleport;
  final List<SubstrateChainModel>? linked;

  String get endpoint => providers.values.first;

  NetworkData toNetworkData(String iconUrl) {
    return NetworkData(
      name: text,
      info: info,
      iconUrl: iconUrl,
      endpoints: List.of(providers.values),
    );
  }

  SubstrateChainModel({
    required this.info,
    required this.text,
    this.paraId,
    required this.providers,
    this.dnslink,
    this.genesisHash,
    this.teleport,
    this.linked,
  });

  factory SubstrateChainModel.fromJson(Map<String, dynamic> json) => SubstrateChainModel(
        info: json["info"],
        text: json["text"],
        paraId: json["paraId"],
        dnslink: json["dnslink"],
        genesisHash: json["genesisHash"],
        providers: Map<String, String>.from(json["providers"]),
        teleport: json["teleport"] != null ? List<int>.from(json["teleport"]) : null,
        linked: json['linked'] != null
            ? List.from(List.of(json['linked']).map((e) => SubstrateChainModel.fromJson(e)))
            : null,
      );
}
