import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/components/flat_button_long_outlined.dart';
import 'package:hashed/components/full_page_error_indicator.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/authentication/recover/recover_account_success/interactor/viewmodels/recover_account_success_bloc.dart';
import 'package:hashed/screens/authentication/recover/recover_account_success/interactor/viewmodels/recover_account_success_page_command.dart';
import 'package:hashed/screens/settings/components/settings_card.dart';
import 'package:hashed/utils/short_string.dart';

class RecoverAccountSuccessView extends StatelessWidget {
  const RecoverAccountSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<RecoverAccountSuccessBloc, RecoverAccountSuccessState>(
    return BlocConsumer<RecoverAccountSuccessBloc, RecoverAccountSuccessState>(
      listenWhen: (_, current) => current.pageCommand != null,
      listener: (context, state) async {
        final pageCommand = state.pageCommand;
        if (pageCommand is ShowCancelCompleteDialogPageCommand) {
          _showCancelCompleteDialog(context);
        }
      },
      builder: (context, state) {
        switch (state.pageState) {
          case PageState.loading:
            return const FullPageLoadingIndicator();
          case PageState.failure:
            return FullPageErrorIndicator(
              errorMessage: 'Oops, Something went wrong.',
              buttonTitle: 'Refresh',
              buttonOnPressed: () => BlocProvider.of<RecoverAccountSuccessBloc>(context).add(const OnRefreshTapped()),
            );
          case PageState.initial:
          case PageState.success:
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text('Your Account', textAlign: TextAlign.start),
                      subtitle: Text(accountService.currentAccount.address, textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 8),
                    SettingsCard(
                      icon: const Icon(Icons.refresh),
                      title: "Recover ${state.recoverAmount.amountStringWithSymbol()}",
                      description: "Recover all HSD tokens from ${state.lostAccount.shorter}",
                      onTap: () async {
                        BlocProvider.of<RecoverAccountSuccessBloc>(context).add(OnRecoverFundsTapped(
                          rescuer: accountService.currentAccount.address,
                          lostAccount: state.lostAccount,
                        ));
                      },
                    ),
                    if (state.activeRecoveryModel != null) ...[
                      const SizedBox(height: 10),
                      SettingsCard(
                        icon: const Icon(Icons.delete_forever),
                        title: "Remove active recovery",
                        description: "Recover funds paid to create the recovery.",
                        onTap: () async {
                          BlocProvider.of<RecoverAccountSuccessBloc>(context).add(const OnRemoveActiveRecoveryTapped());
                        },
                      ),
                    ],
                    if (!state.guardiansConfig.isEmpty) ...[
                      const SizedBox(height: 10),
                      SettingsCard(
                        icon: const Icon(Icons.clear_rounded),
                        title: "Remove guardians configuration",
                        description: "Remove guardians for ${state.lostAccount.shorter}",
                        onTap: () async {
                          BlocProvider.of<RecoverAccountSuccessBloc>(context)
                              .add(const OnRemoveGuardiansConfigTapped());
                        },
                      ),
                    ],
                    const Expanded(child: SizedBox.expand()),
                    FlatButtonLongOutlined(
                      title: "Remove This Recovery",
                      onPressed: () =>
                          BlocProvider.of<RecoverAccountSuccessBloc>(context).add(const OnCleanupAndRemoveTapped()),
                    )
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  void _showCancelCompleteDialog(BuildContext buildContext) {
    showDialog(
      context: buildContext,
      builder: (context) {
        return CustomDialog(
          onSingleLargeButtonPressed: () {
            Navigator.popUntil(context, (route) => route.settings.name == Routes.recoverAccountOverview);
          },
          icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
          singleLargeButtonTitle: "Done",
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Text("Recovery closed successfully!")],
            ),
          ],
        );
      },
    );
  }
}
