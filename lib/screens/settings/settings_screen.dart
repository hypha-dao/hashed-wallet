import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/settings/components/biometric_enabled_dialog.dart';
import 'package:seeds/screens/settings/components/guardian_security_card.dart';
import 'package:seeds/screens/settings/components/settings_card.dart';
import 'package:seeds/screens/settings/interactor/viewmodels/settings_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:share/share.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: IconButton(
                icon: const Icon(Icons.login_outlined),
                onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(const OnLogout()),
              ))
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            SettingsBloc(BlocProvider.of<AuthenticationBloc>(context))..add(const SetUpInitialValues()),
        child: MultiBlocListener(
          listeners: [
            BlocListener<SettingsBloc, SettingsState>(
              listenWhen: (_, current) => current.navigateToGuardians != null,
              listener: (context, _) => NavigationService.of(context).navigateTo(Routes.guardianTabs),
            ),
            BlocListener<SettingsBloc, SettingsState>(
              listenWhen: (_, current) => current.navigateToVerification != null,
              listener: (context, _) {
                BlocProvider.of<SettingsBloc>(context).add(const ResetNavigateToVerification());
                NavigationService.of(context).navigateTo(Routes.verification).then((isValid) {
                  if (isValid ?? false) {
                    BlocProvider.of<SettingsBloc>(context).add(const OnValidVerification());
                  }
                });
              },
            ),
            BlocListener<SettingsBloc, SettingsState>(
              listenWhen: (previous, current) =>
                  previous.isSecureBiometric == false && current.isSecureBiometric == true,
              listener: (context, _) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const BiometricEnabledDialog(),
                );
              },
            ),
          ],
          child: BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (previous, current) => previous.pageState != current.pageState,
            builder: (context, state) {
              switch (state.pageState) {
                case PageState.initial:
                  return const SizedBox.shrink();
                case PageState.loading:
                  return const FullPageLoadingIndicator();
                case PageState.failure:
                  return const FullPageErrorIndicator();
                case PageState.success:
                  return SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        SettingsCard(
                          icon: const Icon(Icons.update),
                          title: context.loc.securityExportPrivateKeyTitle,
                          description: context.loc.securityExportPrivateKeyDescription,
                          onTap: () => Share.share(settingsStorage.privateKey!),
                        ),
                        BlocBuilder<SettingsBloc, SettingsState>(
                          buildWhen: (previous, current) => previous.hasNotification != current.hasNotification,
                          builder: (context, state) {
                            return GuardianSecurityCard(
                              onTap: () => BlocProvider.of<SettingsBloc>(context)..add(const OnGuardiansCardTapped()),
                              hasNotification: state.hasNotification,
                            );
                          },
                        ),
                        if (state.shouldShowExportRecoveryPhrase)
                          SettingsCard(
                            icon: const Icon(Icons.insert_drive_file),
                            title: context.loc.security12WordRecoveryPhraseTitle,
                            description: context.loc.security12WordRecoveryPhraseDescription,
                            onTap: () {
                              NavigationService.of(context).navigateTo(Routes.recoveryPhrase);
                            },
                          )
                        else
                          const SizedBox.shrink(),
                        SettingsCard(
                          icon: const Icon(Icons.lock_outline),
                          title: context.loc.securitySecureWithPinTitle,
                          titleWidget: BlocBuilder<SettingsBloc, SettingsState>(
                            buildWhen: (previous, current) => previous.isSecurePasscode != current.isSecurePasscode,
                            builder: (context, state) {
                              return Switch(
                                value: state.isSecurePasscode!,
                                onChanged: (_) =>
                                    BlocProvider.of<SettingsBloc>(context)..add(const OnPasscodePressed()),
                                // activeTrackColor: AppColors.canopy,
                                // activeColor: AppColors.white,
                              );
                            },
                          ),
                          description: context.loc.securitySecureWithPinDescription,
                        ),
                        SettingsCard(
                          icon: const Icon(Icons.fingerprint),
                          title: context.loc.securitySecureWithTouchFaceIDTitle,
                          titleWidget: BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, state) {
                              return Switch(
                                value: state.isSecureBiometric!,
                                onChanged: state.isSecurePasscode!
                                    ? (_) {
                                        BlocProvider.of<SettingsBloc>(context).add(const OnBiometricPressed());
                                      }
                                    : null,
                                // activeTrackColor: AppColors.canopy,
                                // activeColor: AppColors.white,
                              );
                            },
                          ),
                          description: context.loc.securitySecureWithTouchFaceIDDescription,
                        ),
                      ],
                    ),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
