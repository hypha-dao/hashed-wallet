import 'dart:convert';

import 'package:hashed/datasource/local/models/substrate_extrinsic_model.dart';
import 'package:hashed/screens/transfer/scan/scan_confirmation_action.dart';

class SubstrateTransactionModel {
  final SubstrateExtrinsicModel extrinsic;
  final List parameters;

  const SubstrateTransactionModel({
    required this.extrinsic,
    required this.parameters,
  });

  factory SubstrateTransactionModel.fromJson(Map<String, dynamic> json) {
    final extrinsic = SubstrateExtrinsicModel.fromJson(json["extrinsic"]);
    final params = jsonDecode(json["params"]) as List;
    return SubstrateTransactionModel(
      extrinsic: extrinsic,
      parameters: params,
    );
  }

  /// Note: The fields in this method correspond to fields that will be used in the
  /// JavaScript package - these field names cannot be changed.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'extrinsic': extrinsic.toJson(),
        'params': jsonEncode(parameters),
      };

  ScanConfirmationActionData toSendConfirmationActionData() {
    var paramIndex = 1;
    final parameterMap = <String, String>{};
    for (final param in parameters) {
      final name = "Parameter $paramIndex";
      parameterMap[name] = param.toString();
      paramIndex++;
    }
    return ScanConfirmationActionData(
      pallet: extrinsic.module,
      extrinsic: extrinsic.call,
      actionParams: parameterMap,
    );
  }
}
