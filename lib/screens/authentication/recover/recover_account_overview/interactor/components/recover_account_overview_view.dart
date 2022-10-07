import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/full_page_error_indicator.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/authentication/recover/recover_account_overview/interactor/viewmodels/recover_account_overview_bloc.dart';
import 'package:hashed/screens/settings/components/account_card.dart';
import 'package:hashed/screens/settings/components/settings_card.dart';
import 'package:hashed/utils/ThemeBuildContext.dart';
import 'package:hashed/utils/short_string.dart';

class RecoverAccountOverviewView extends StatelessWidget {
  const RecoverAccountOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverAccountOverviewBloc, RecoverAccountOverviewState>(
      builder: (context, state) {
        switch (state.pageState) {
          case PageState.loading:
            return const FullPageLoadingIndicator();
          case PageState.failure:
            return FullPageErrorIndicator(
              errorMessage: 'Oops, Something went wrong.',
              buttonTitle: 'Refresh',
              buttonOnPressed: () => BlocProvider.of<RecoverAccountOverviewBloc>(context).add(const OnRefreshTapped()),
            );
          case PageState.initial:
          case PageState.success:
            if (state.recoveredAccounts.isNotEmpty) {
              print("rec acct ${state.recoveredAccounts}");
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SettingsCard(
                    icon: const Icon(Icons.replay_circle_filled_outlined),
                    title: "Recover an Account",
                    description: "Recover an account with the help of the guardians set for that account.",
                    onTap: () async {
                      BlocProvider.of<RecoverAccountOverviewBloc>(context).add(const OnRecoverAccountTapped());
                    },
                  ),
                  const SizedBox(height: 16),
                  if (state.activeRecovery.isNotEmpty) ...[
                    SettingsCard(
                        backgroundColor: context.colorScheme.tertiaryContainer,
                        textColor: context.colorScheme.onTertiaryContainer,
                        icon: const Icon(Icons.keyboard_command_key),
                        title: "Recovery in Process",
                        description: "Recovering    ${state.activeRecovery.lostAccount.shorter}",
                        onTap: () async {
                          BlocProvider.of<RecoverAccountOverviewBloc>(context)
                              .add(OnRecoveryInProcessTapped(state.activeRecovery.lostAccount));
                        }),
                    const SizedBox(height: 16)
                  ],
                  if (state.recoveredAccounts.isNotEmpty)
                    Text(
                      "Recovered Accounts",
                      style: context.textTheme.headline6,
                    ),
                  const SizedBox(height: 16),
                  ...state.recoveredAccounts.map((e) => AccountCard(
                      onTap: () => NavigationService.of(context).navigateTo(Routes.recoverAccountSuccess, arguments: e),
                      address: e,
                      icon: const Icon(
                        Icons.bookmark,
                      ))),
                ],
              ),
            );
        }
      },
    );
  }
}
