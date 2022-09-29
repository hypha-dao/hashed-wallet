import 'package:flutter/material.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/utils/ThemeBuildContext.dart';
import 'package:hashed/utils/short_string.dart';

class AccountCard extends StatelessWidget {
  final String address;
  final String? accountName;
  final Widget icon;

  final GestureTapCallback? onTap;

  final Color? backgroundColor;
  final Color? textColor;

  const AccountCard({
    super.key,
    required this.address,
    required this.icon,
    this.accountName,
    this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor ?? context.colorScheme.surface,
            borderRadius: BorderRadius.circular(defaultCardBorderRadius),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    icon,
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16, bottom: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              address.shorter,
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: textColor ?? context.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: Text(
                            accountName ?? "",
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: (textColor ?? context.colorScheme.onSurface).withAlpha(180),
                            ),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
