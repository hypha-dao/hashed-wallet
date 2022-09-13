import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hashed/components/divider_jungle.dart';
import 'package:hashed/components/notification_badge.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/utils/ThemeBuildContext.dart';
import 'package:hashed/utils/build_context_extension.dart';

class GuardianSecurityCard extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool hasNotification;

  const GuardianSecurityCard({super.key, this.onTap, this.hasNotification = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(defaultCardBorderRadius),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(defaultCardBorderRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 8.0),
                    child: SvgPicture.asset('assets/images/security/key_guardians_icon.svg'),
                  ),
                ],
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Key Guardians",
                                      style: context.textTheme.button,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (hasNotification) const NotificationBadge()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const DividerJungle(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16, top: 6),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(context.loc.securityGuardiansDescription),
                            )
                          ],
                        ),
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
