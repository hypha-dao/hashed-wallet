import 'dart:convert';

import 'package:hashed/datasource/local/models/substrate_extrinsic_model.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/screens/transfer/scan/scan_confirmation_action.dart';
import 'package:hashed/utils/short_string.dart';

class SubstrateTransactionModel {
  final SubstrateExtrinsicModel extrinsic;
  final List parameters;

  const SubstrateTransactionModel({
    required this.extrinsic,
    required this.parameters,
  });

  factory SubstrateTransactionModel.fromJson(Map<String, dynamic> json) {
    // final extrinsic = SubstrateExtrinsicModel.fromJson(json["extrinsic"]);
    final params = jsonDecode(json["params"]) as List;
    return SubstrateTransactionModel(
      extrinsic: SubstrateExtrinsicModel.fromJson(json),
      parameters: params,
    );
  }

  /// Note: The fields in this method correspond to fields that will be used in the
  /// JavaScript package - these field names cannot be changed.
  Map<String, dynamic> toJson() => <String, dynamic>{
        ...extrinsic.toJson(),
        'params': jsonEncode(parameters),
      };

  ScanConfirmationActionData toSendConfirmationActionData() {
    var paramIndex = 1;
    var parameterMap = getSpecialParameters();
    if (parameterMap == null) {
      parameterMap = <String, String>{};
      for (final param in parameters) {
        final name = "Parameter $paramIndex";
        parameterMap[name] = param.toString();
        paramIndex++;
      }
    }
    return ScanConfirmationActionData(
      pallet: extrinsic.module,
      extrinsic: extrinsic.call,
      actionParams: parameterMap,
    );
  }

  Map<String, String>? getSpecialParameters() {
    if (extrinsic.module == "balances") {
      if (extrinsic.call == "transfer") {
        // transfer(dest: MultiAddress, value: Compact<u128>)
        final token = settingsStorage.selectedToken;
        final amount = token.amountFromUnit(parameters[1].toString());
        final dataModel = TokenDataModel(amount, token: token);
        return {
          "dest": parameters[0].toString().shorter,
          "value": dataModel.amountStringWithSymbol(),
        };
      }
    }
    return null;
  }
}
