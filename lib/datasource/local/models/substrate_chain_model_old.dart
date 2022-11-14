// TBD: Will be removed
// TODO(n13): Remove and replace with the new model

class SubstrateChainModelOld {
  final String name;
  final String info;
  final int? paraId;
  final Map<String, String> endpoints;
  // final int ss58;

  String get endpoint => endpoints.values.first;

  SubstrateChainModelOld({
    required this.name,
    required this.info,
    this.paraId,
    required this.endpoints,
    // required this.ss58,
  });

  factory SubstrateChainModelOld.fromJson(Map<String, dynamic> json) => SubstrateChainModelOld(
        name: json["text"],
        info: json["info"],
        paraId: json["paraId"],
        endpoints: Map<String, String>.from(json["providers"]),
        // ss58: json['ss58'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'info': info,
        'text': name,
        'providers': endpoints,
        // 'ss58': ss58,
      };
}
