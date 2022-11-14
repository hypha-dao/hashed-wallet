import 'package:hashed/datasource/local/models/substrate_chain_model_old.dart';

class SubstrateChainContainer {
  final String header;
  final bool isRelayChain;
  final List<SubstrateChainModelOld>? list;
  final SubstrateChainModelOld? relayChain;
  SubstrateChainContainer({
    required this.header,
    required this.isRelayChain,
    this.list,
    this.relayChain,
  });
  factory SubstrateChainContainer.fromJson(Map<String, dynamic> json) => SubstrateChainContainer(
        header: json["header"],
        isRelayChain: json["isRelayChain"],
        list:
            json["isRelayChain"] ? null : List.of(json["list"]).map((e) => SubstrateChainModelOld.fromJson(e)).toList(),
        relayChain: json["isRelayChain"] ? SubstrateChainModelOld.fromJson(json["chain"]) : null,
      );
}
