class ChainProperties {
  /// Note: header has a bunch of other fields, but we only use number
  final int ss58Format;
  final List<int> tokenDecimals;
  final List<String> tokenSymbol;

  // all the following are optional and can be null
  final String? displayName;
  // final String? network;
  // final int? prefix;
  final String? standardAccount;
  final String? website;

  ChainProperties({
    required this.ss58Format,
    required this.tokenDecimals,
    required this.tokenSymbol,
    this.displayName,
    this.network,
    this.prefix,
    this.standardAccount,
    this.website,
  });

  final String network;
  final int prefix;

  // json: {ss58Format: 0, tokenDecimals: [10], tokenSymbol: [DOT]}
  factory ChainProperties.fromJson(Map<String, dynamic> json) {
    return ChainProperties(
      ss58Format: json["ss58Format"],
      tokenDecimals: List<int>.from(json["tokenDecimals"]),
      tokenSymbol: List<String>.from(json["tokenSymbol"]),
      displayName: json["displayName"], // can be null
      network: json["network"], // can be null
      prefix: json["prefix"],
      standardAccount: json["standardAccount"],
      website: json["website"],
    );
  }
}
