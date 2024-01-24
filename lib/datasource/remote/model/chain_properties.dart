class ChainProperties {
  final int ss58Format;
  final List<int> tokenDecimals;
  final List<String> tokenSymbol;

  // all the following are optional and can be null
  final String? displayName;
  final String? network;
  final int? prefix;
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

  // DOT
  // {ss58Format: 0, tokenDecimals: [10], tokenSymbol: [DOT]}

  factory ChainProperties.fromJson(Map<String, dynamic> json) {
    return ChainProperties(
      ss58Format: json["ss58Format"] as int,
      tokenDecimals: List<int>.from(json["tokenDecimals"] as Iterable<int>),
      tokenSymbol: List<String>.from(json["tokenSymbol"] as Iterable<int>),
      displayName: json["displayName"] as String?,
      network: json["network"] as String?,
      prefix: json["prefix"] as int?,
      standardAccount: json["standardAccount"] as String?,
      website: json["website"] as String?,
    );
  }
}
