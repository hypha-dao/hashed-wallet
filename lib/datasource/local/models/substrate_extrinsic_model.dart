import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/local/models/tx_sender_data.dart';

const defaultTipValue = '0';
const defaultIsUnsignedValue = false;

/// From SDK TxInfoData - it's a model class that encodes a substrate extrinsic call

class SubstrateExtrinsicModel extends Equatable {
  final String module;
  final String call;
  final TxSenderData? sender;
  final String? tip;
  final bool? isUnsigned;

  /// proxy for calling recovery.asRecovered
  final TxSenderData? proxy;

  /// txName for calling treasury.approveProposal & treasury.rejectProposal
  final String? txName;

  const SubstrateExtrinsicModel({
    required this.module,
    required this.call,
    required this.sender,
    this.tip = defaultTipValue,
    this.isUnsigned = defaultIsUnsignedValue,
    this.proxy,
    this.txName,
  });

  factory SubstrateExtrinsicModel.fromJson(Map<String, dynamic> json) {
    final sender = json["sender"] != null ? TxSenderData.fromJsonOrPlaceholder(json["sender"]) : null;
    final proxy = json["proxy"] != null ? TxSenderData.fromJson(json["proxy"]) : null;
    return SubstrateExtrinsicModel(
        module: json['module'] as String,
        call: json['call'] as String,
        sender: sender,
        tip: json["tip"] ?? defaultTipValue,
        isUnsigned: json["isUnsigned"] ?? defaultIsUnsignedValue,
        proxy: proxy,
        txName: json['txName']);
  }

  /// Returns an extrinsic model with sender replaced by account
  /// if sender is set to TxSenderData.signer
  SubstrateExtrinsicModel resolvePlaceholders(String account) {
    return SubstrateExtrinsicModel(
      module: module,
      call: call,
      sender: sender == TxSenderData.signer ? TxSenderData(account) : sender,
      tip: tip,
      isUnsigned: isUnsigned,
      proxy: proxy,
      txName: txName,
    );
  }

  /// Note: The fields in this method correspond to fields that will be used in the
  /// JavaScript package - these field names cannot be changed.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'module': module,
      'call': call,
    };
    if (sender != null) {
      map['sender'] = sender!.toJsonOrPlaceholder();
    }
    if (proxy != null) {
      map['proxy'] = proxy!.toJson();
    }
    if (tip != null && tip != defaultTipValue) {
      map['tip'] = tip;
    }
    if (isUnsigned != null && isUnsigned != defaultIsUnsignedValue) {
      map['isUnsigned'] = isUnsigned;
    }
    if (txName != null) {
      map['txName'] = txName;
    }
    return map;
  }

  @override
  List<Object?> get props => [module, call, sender, tip, isUnsigned, proxy, txName];
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
