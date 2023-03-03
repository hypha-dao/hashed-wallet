import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hashed/components/custom_dialog.dart';
import 'package:hashed/components/full_page_error_indicator.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/i18n/app/app.i18.dart';
import 'package:hashed/screens/app/account_under_recovery/interactor/viewmodels/account_under_recovery_bloc.dart';
import 'package:hashed/screens/app/account_under_recovery/interactor/viewmodels/account_under_recovery_event.dart';
import 'package:hashed/screens/app/account_under_recovery/interactor/viewmodels/account_under_recovery_state.dart';

class AccountUnderRecoveryScreen extends StatelessWidget {
  const AccountUnderRecoveryScreen({super.key});

  void _showSuccessDialog(BuildContext buildContext) {
    showDialog(
      context: buildContext,
      builder: (context) {
        return CustomDialog(
          onSingleLargeButtonPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
          singleLargeButtonTitle: "Done",
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Text("Recovery removed successfully!")],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List<ActiveRecoveryModel>?;

    return BlocProvider(
        create: (_) => AccountUnderRecoveryBloc(arguments),
        child: BlocListener<AccountUnderRecoveryBloc, AccountUnderRecoveryState>(
            listenWhen: (_, current) => current.pageCommand != null,
            listener: (context, state) {
              final pageCommand = state.pageCommand;

              if (pageCommand is OnShowSuccessDialogPageCommand) {
                _showSuccessDialog(context);
              }
            },
            child: BlocBuilder<AccountUnderRecoveryBloc, AccountUnderRecoveryState>(builder: (context, state) {
              return state.pageState == PageState.loading
                  ? const FullPageLoadingIndicator()
                  : state.pageState == PageState.failure
                      ? FullPageErrorIndicator(
                          errorMessage: "Unable to stop recovery.",
                          buttonTitle: "Cancel",
                          buttonOnPressed: () => Navigator.pop(context),
                        )
                      : Center(
                          child: SingleChildScrollView(
                            child: CustomDialog(
                              singleLargeButtonLoading: state.pageState == PageState.loading,
                              singleLargeButtonTitle: 'Cancel Recovery'.i18n,
                              onSingleLargeButtonPressed: () {
                                BlocProvider.of<AccountUnderRecoveryBloc>(context)
                                    .add(const OnStopGuardianActiveRecoveryTapped());
                              },
                              children: [
                                Container(
                                  height: 200,
                                  width: 250,
                                  decoration: const BoxDecoration(
                                    //color: AppColors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/guardians/guardian_shield.png'),
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Recovery Mode Initiated'.i18n,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Text(
                                    'Someone has initiated the Recovery process for your account. If you did not request to recover your account please select cancel recovery.'
                                        .i18n,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
            })));
  }
}
