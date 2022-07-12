import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/settings/components/biometric_enabled_dialog.dart';
import 'package:seeds/screens/profile_screens/settings/components/guardian_security_card.dart';
import 'package:seeds/screens/profile_screens/settings/components/settings_card.dart';
import 'package:seeds/screens/profile_screens/settings/interactor/viewmodels/settings_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:share/share.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.securityTitle)),
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
                          buildWhen: (previous, current) =>
                              previous.hasNotification != current.hasNotification ||
                              previous.guardiansStatus != current.guardiansStatus,
                          builder: (context, state) {
                            return GuardianSecurityCard(
                              onTap: () => BlocProvider.of<SettingsBloc>(context)..add(const OnGuardiansCardTapped()),
                              hasNotification: state.hasNotification,
                              guardiansStatus: state.guardiansStatus,
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
