import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:hashed/components/full_page_error_indicator.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/settings/components/biometric_enabled_dialog.dart';
import 'package:hashed/screens/settings/components/guardian_security_card.dart';
import 'package:hashed/screens/settings/components/logout_recovery_phrase_dialog.dart';
import 'package:hashed/screens/settings/components/settings_card.dart';
import 'package:hashed/screens/settings/interactor/viewmodels/page_commands.dart';
import 'package:hashed/screens/settings/interactor/viewmodels/settings_bloc.dart';
import 'package:hashed/utils/build_context_extension.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: BlocProvider(
        create: (context) =>
            SettingsBloc(BlocProvider.of<AuthenticationBloc>(context))..add(const SetUpInitialValues()),
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (BuildContext context, SettingsState state) {
            final pageCommand = state.pageCommand;
            BlocProvider.of<SettingsBloc>(context).add(const ClearSettingsPageCommand());
            if (pageCommand is NavigateToRoute) {
              NavigationService.of(context).navigateTo(pageCommand.route);
            } else if (pageCommand is ShowLogoutRecoveryPhraseDialog) {
              showDialog<void>(
                context: context,
                builder: (_) {
                  return BlocProvider.value(
                    value: BlocProvider.of<SettingsBloc>(context),
                    child: const LogoutRecoveryPhraseDialog(),
                  );
                },
              ).whenComplete(() => BlocProvider.of<SettingsBloc>(context).add(const ResetShowLogoutButton()));
            } else if (pageCommand is ShowBiometricDialog) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) => const BiometricEnabledDialog(),
              );
            } else if (pageCommand is NavigateToVerification) {
              NavigationService.of(context).navigateTo(Routes.verification).then((isValid) {
                if (isValid ?? false) {
                  BlocProvider.of<SettingsBloc>(context).add(const OnValidVerification());
                }
              });
            }
          },
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
                          icon: SvgPicture.asset(
                            'assets/images/clarity_network_setting.svg',
                            width: 24,
                            height: 24,
                          ),
                          title: "Switch Network",
                          description:
                              "Easily switch between a selection of Parachains connected to the Polkadot Network",
                          onTap: () async {
                            BlocProvider.of<SettingsBloc>(context).add(const OnExportSwitchNetworkTapped());
                          },
                        ),
                        SettingsCard(
                          icon: const Icon(Icons.update),
                          title: "Export Private Key",
                          description: "Export your private key so you can easily recover and access your account.",
                          onTap: () async {
                            BlocProvider.of<SettingsBloc>(context).add(const OnExportPrivateKeyCardTapped());
                          },
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
                        SettingsCard(
                          icon: const Icon(Icons.shield),
                          title: "Recover Account",
                          description: "Recover an account with the help of the guardians set for that account.",
                          onTap: () async {
                            BlocProvider.of<SettingsBloc>(context).add(const OnRecoverAccountTapped());
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
                          icon: const Icon(Icons.logout),
                          title: 'Logout',
                          description: "Log out of the app.",
                          onTap: () => BlocProvider.of<SettingsBloc>(context).add(const OnLogoutButtonPressed()),
                        ),

                        /// Secure with Pin disabled
                        ///
                        // SettingsCard(
                        //   icon: const Icon(Icons.lock_outline),
                        //   title: "Secure with Pin",
                        //   titleWidget: BlocBuilder<SettingsBloc, SettingsState>(
                        //     buildWhen: (previous, current) => previous.isSecurePasscode != current.isSecurePasscode,
                        //     builder: (context, state) {
                        //       return Switch(
                        //         value: state.isSecurePasscode!,
                        //         onChanged: (_) =>
                        //             BlocProvider.of<SettingsBloc>(context)..add(const OnPasscodePressed()),
                        //         // activeTrackColor: AppColors.canopy,
                        //         // activeColor: AppColors.white,
                        //       );
                        //     },
                        //   ),
                        //   description: context.loc.securitySecureWithPinDescription,
                        // ),

                        /// Secure with Face ID disabled
                        ///
                        // SettingsCard(
                        //   icon: const Icon(Icons.fingerprint),
                        //   title: "Secure with Touch/Face ID",
                        //   titleWidget: BlocBuilder<SettingsBloc, SettingsState>(
                        //     builder: (context, state) {
                        //       return Switch(
                        //         value: state.isSecureBiometric!,
                        //         onChanged: state.isSecurePasscode!
                        //             ? (_) {
                        //                 BlocProvider.of<SettingsBloc>(context).add(const OnBiometricPressed());
                        //               }
                        //             : null,
                        //         // activeTrackColor: AppColors.canopy,
                        //         // activeColor: AppColors.white,
                        //       );
                        //     },
                        //   ),
                        //   description: context.loc.securitySecureWithTouchFaceIDDescription,
                        // ),
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
