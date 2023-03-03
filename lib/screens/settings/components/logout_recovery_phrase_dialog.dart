import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/flat_button_long_outlined.dart';
import 'package:hashed/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:hashed/screens/settings/interactor/viewmodels/settings_bloc.dart';

class LogoutRecoveryPhraseDialog extends StatelessWidget {
  const LogoutRecoveryPhraseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return CustomDialog(
          icon: SvgPicture.asset("assets/images/settings/logout_icon.svg"),
          children: [
            Text('Logout'.i18n, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Text(
                    'Save private Recovery Phrase in secure place - to be able to restore access to your wallet later'
                        .i18n,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 36.0),
                  FlatButtonLong(
                    title: 'Save Recovery Phrase'.i18n,
                    onPressed: () =>
                        BlocProvider.of<SettingsBloc>(context).add(const OnSaveRecoveryPhraseButtonPressed()),
                  ),
                  const SizedBox(height: 10.0),
                  if (state.showLogoutButton)
                    FlatButtonLongOutlined(
                      title: 'Logout'.i18n,
                      onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(const OnLogout()),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
