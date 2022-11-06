import 'package:flutter/material.dart';
import 'package:hashed/utils/ThemeBuildContext.dart';

class ScanConfirmationAction extends StatelessWidget {
  final ScanConfirmationActionData data;

  const ScanConfirmationAction({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Row(children: [Text(data.actionName.key), Text(data.actionName.value)]),
          Container(height: 1, color: context.colorScheme.surface),
          ...data.actionParams.entries.map((e) => Row(children: [Text(e.key), Text(e.value)])).toList()
        ],
      ),
    );
  }
}

class ScanConfirmationActionData {
  final MapEntry<String, String> actionName;
  final Map<String, String> actionParams;

  ScanConfirmationActionData({required this.actionName, required this.actionParams});
}
