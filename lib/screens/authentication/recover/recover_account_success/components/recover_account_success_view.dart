import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/full_page_error_indicator.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/authentication/recover/recover_account_success/interactor/viewmodels/recover_account_success_bloc.dart';
import 'package:hashed/screens/settings/components/settings_card.dart';

class RecoverAccountSuccessView extends StatelessWidget {
  const RecoverAccountSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverAccountSuccessBloc, RecoverAccountSuccessState>(
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
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text('Your Account', textAlign: TextAlign.start),
                    subtitle: Text(state.userAccount, textAlign: TextAlign.start),
                  ),
                  const SizedBox(height: 8),
                  SettingsCard(
                    icon: const Icon(Icons.refresh),
                    title: "Recover ${state.recoverAmount}",
                    description: "Recover all HSD tokens from ${state.recoveredAccount}",
                    onTap: () async {
                      BlocProvider.of<RecoverAccountSuccessBloc>(context).add(const OnRecoverFundsTapped());
                    },
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
