class SubstrateBlockHeader {
  /// Note: header has a bunch of other fields, but we only use number
  final int number;

  SubstrateBlockHeader(this.number);

  factory SubstrateBlockHeader.fromJson(Map<String, dynamic> json) {
    return SubstrateBlockHeader(json["number"]!);
  }
}
