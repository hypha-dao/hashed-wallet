import 'package:flutter/material.dart';
import 'package:hashed/datasource/local/models/fiat_data_model.dart';
import 'package:hashed/datasource/local/models/token_data_model.dart';

/// Available Amount
///
/// Used to show available amount or planted amount in a row together with Fiat Conversion
class BalanceRow extends StatelessWidget {
  final String label;
  final TokenDataModel? tokenAmount;
  final FiatDataModel? fiatAmount;

  const BalanceRow({
    super.key,
    required this.label,
    required this.tokenAmount,
    required this.fiatAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(child: Container(alignment: Alignment.centerLeft, child: Text(label))),
            Expanded(
                child: Container(alignment: Alignment.centerRight, child: Text(tokenAmount?.asFormattedString() ?? "")))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(fiatAmount?.asFormattedString() ?? "")]),
        )
      ],
    );
  }
}
