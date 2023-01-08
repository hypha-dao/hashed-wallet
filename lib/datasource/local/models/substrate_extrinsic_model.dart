/// From SDK TxInfoData - it's a model class that encodes a substrate extrinsic call
class SubstrateExtrinsicModel {
  SubstrateExtrinsicModel({
    required this.module,
    required this.call,
    required this.sender,
    this.tip = '0',
    this.isUnsigned = false,
    this.proxy,
    this.txName,
  });

  String module;
  String call;
  TxSenderData? sender;
  String? tip;

  bool? isUnsigned;

  /// proxy for calling recovery.asRecovered
  TxSenderData? proxy;

  /// txName for calling treasury.approveProposal & treasury.rejectProposal
  String? txName;

  factory SubstrateExtrinsicModel.fromJson(Map<String, dynamic> json) {
    final sender = TxSenderData.fromJson(json["sender"]);
    final proxy = TxSenderData.fromJson(json["proxy"]);
    return SubstrateExtrinsicModel(
        module: json['module'] as String,
        call: json['call'] as String,
        sender: sender,
        tip: json["tip"],
        isUnsigned: json["isUnsigned"],
        proxy: proxy,
        txName: json['txName']);
  }

  /// Note: The fields in this method correspond to fields that will be used in the
  /// JavaScript package - these field names cannot be changed.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'module': module,
        'call': call,
        'sender': sender?.toJson(),
        'tip': tip,
        'isUnsigned': isUnsigned,
        'proxy': proxy?.toJson(),
        'txName': txName,
      };
}

// TODO(n13): Clean up I don't think we ever need pub key
// These classes are carry overs from substrate SDK - refactor them
class TxSenderData {
  TxSenderData(this.address);

  final String? address;

  // ignore: prefer_constructors_over_static_methods
  static TxSenderData fromJson(Map<String, dynamic> json) => TxSenderData(
        json['address'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address,
      };
}

// TODO(n13): These classes are carry overs from substrate SDK - refactor them
class TxFeeEstimateResult {
  dynamic weight;
  dynamic partialFee;

  // ignore: prefer_constructors_over_static_methods
  static TxFeeEstimateResult fromJson(Map<String, dynamic> json) => TxFeeEstimateResult()
    ..weight = json['weight']
    ..partialFee = json['partialFee'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'weight': weight,
        'partialFee': partialFee,
      };
}
