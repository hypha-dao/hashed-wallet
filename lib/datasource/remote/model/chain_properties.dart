class ChainProperties {
  /// Note: header has a bunch of other fields, but we only use number
  final int ss58Format;
  final List<int> tokenDecimals;
  final List<String> tokenSymbol;
  final String? displayName;
  final String network;
  final int prefix;
  final String? standardAccount;
  final String? website;

  ChainProperties({
    required this.ss58Format,
    required this.tokenDecimals,
    required this.tokenSymbol,
    this.displayName,
    required this.network,
    required this.prefix,
    this.standardAccount,
    this.website,
  });

  factory ChainProperties.fromJson(Map<String, dynamic> json) {
    return ChainProperties(
      ss58Format: json["ss58Format"],
      tokenDecimals: List<int>.from(json["tokenDecimals"]),
      tokenSymbol: List<String>.from(json["tokenSymbol"]),
      displayName: json["displayName"],
      network: json["network"],
      prefix: json["prefix"],
      standardAccount: json["standardAccount"],
      website: json["website"],
    );
  }
}
