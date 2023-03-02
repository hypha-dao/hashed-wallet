import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/full_page_error_indicator.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/components/text_form_field_custom.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/authentication/recover/recover_account_details/interactor/viewmodels/recover_account_details_bloc.dart';
import 'package:hashed/utils/ThemeBuildContext.dart';
import 'package:hashed/utils/short_string.dart';
import 'package:share_plus/share_plus.dart';

class RecoverAccountDetailsView extends StatelessWidget {
  const RecoverAccountDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverAccountDetailsBloc, RecoverAccountDetailsState>(
      builder: (context, state) {
        switch (state.pageState) {
          case PageState.loading:
            return const FullPageLoadingIndicator();
          case PageState.failure:
            return FullPageErrorIndicator(
              errorMessage: 'Oops, Something went wrong.',
              buttonTitle: 'Refresh',
              buttonOnPressed: () => BlocProvider.of<RecoverAccountDetailsBloc>(context).add(const OnRefreshTapped()),
            );
          case PageState.initial:
          case PageState.success:
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    children: [
                      TextFormFieldCustom(
                        enabled: false,
                        labelText: 'Recovery Link to send to your Guardians',
                        suffixIcon: const SizedBox.shrink(),
                        controller: TextEditingController(text: state.linkToActivateGuardians?.toString()),
                      ),
                      Positioned(
                        right: 0,
                        top: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8, top: 8),
                          child: IconButton(
                            icon: const Icon(Icons.share),
                            splashRadius: 30,
                            onPressed: () async {
                              await Share.share(state.linkToActivateGuardians!.toString());
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(state.approvedAccounts.length.toString(), style: context.textTheme.headline6),
                      Text("/${state.totalGuardiansCount}", style: context.textTheme.headline6),
                      const SizedBox(width: 24),
                      Flexible(
                        child: Text.rich(TextSpan(
                          text: 'Guardians signed, you need',
                          children: [
                            TextSpan(text: ' ${state.threshold} ', style: context.textTheme.headline6),
                            const TextSpan(text: "to recover."),
                          ],
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  ...state.approvedAccounts.map((e) => ListTile(
                        title: Text(e.shorter),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )),
                  ...state.pendingAccounts.map((e) => ListTile(
                        title: Text(e.shorter),
                        trailing: Text(
                          'pending',
                          style: TextStyle(color: context.colorScheme.secondary),
                        ),
                      ))
                ],
              ),
            );
        }
      },
    );
  }
}
