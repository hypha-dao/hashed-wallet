import 'package:hashed/datasource/local/models/substrate_chain_model_old.dart';
import 'package:hashed/datasource/remote/model/substrate_chain_model.dart';

class SubstrateChainContainer {
  final String header;
  final bool isRelayChain;
  final List<SubstrateChainModel>? list;
  final SubstrateChainModel? relayChain;
  SubstrateChainContainer({
    required this.header,
    required this.isRelayChain,
    this.list,
    this.relayChain,
  });
  factory SubstrateChainContainer.fromJson(Map<String, dynamic> json) => SubstrateChainContainer(
        header: json["header"],
        isRelayChain: json["isRelayChain"],
        list: json["isRelayChain"] ? null : List.of(json["list"]).map((e) => SubstrateChainModel.fromJson(e)).toList(),
        relayChain: json["isRelayChain"] ? SubstrateChainModel.fromJson(json["chain"]) : null,
      );
}
