import 'package:flutter/material.dart';
import 'package:hashed/utils/ThemeBuildContext.dart';

class ScanConfirmationAction extends StatelessWidget {
  final ScanConfirmationActionData data;

  const ScanConfirmationAction({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.tertiaryContainer),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.pallet,
                style: context.textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                data.extrinsic,
                style: context.textTheme.subtitle2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          const SizedBox(height: 4),
          Container(height: 1, color: context.colorScheme.tertiaryContainer),
          const SizedBox(height: 4),
          ...data.actionParams.entries
              .map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.key,
                        style: context.textTheme.subtitle2?.copyWith(color: Colors.white.withOpacity(0.8)),
                      ),
                      Text(
                        e.value,
                        style: context.textTheme.subtitle2,
                      )
                    ],
                  ))
              .toList()
        ],
      ),
    );
  }
}

class ScanConfirmationActionData {
  // final MapEntry<String, String> actionName;
  final String pallet;
  final String extrinsic;
  final Map<String, String> actionParams;

  ScanConfirmationActionData({required this.pallet, required this.extrinsic, required this.actionParams});
}
