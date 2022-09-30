import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/full_page_error_indicator.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/viewmodels/recover_account_timer_bloc.dart';

class RecoverAccountTimerView extends StatelessWidget {
  const RecoverAccountTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverAccountTimerBloc, RecoverAccountTimerState>(
      builder: (context, state) {
        switch (state.pageState) {
          case PageState.loading:
            return const FullPageLoadingIndicator();
          case PageState.failure:
            return FullPageErrorIndicator(
              errorMessage: 'Oops, Something went wrong.',
              buttonTitle: 'Refresh',
              buttonOnPressed: () => BlocProvider.of<RecoverAccountTimerBloc>(context).add(const OnRefreshTapped()),
            );
          case PageState.initial:
          case PageState.success:
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Your Key Guardians have accepted your request to recover your account. You account will be unlocked in 24hrs. ',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Icon(Icons.check_circle_outline, size: 100, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 66),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(state.currentRemainingTime?.hoursFormatted ?? '00',
                              style: Theme.of(context).textTheme.headline4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(':', style: Theme.of(context).textTheme.headline4),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(state.currentRemainingTime?.minFormatted ?? '00',
                              style: Theme.of(context).textTheme.headline4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(':', style: Theme.of(context).textTheme.headline4),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('${state.currentRemainingTime?.secFormatted ?? '00'} ',
                              style: Theme.of(context).textTheme.headline4),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text('Hours Left', style: Theme.of(context).textTheme.subtitle2),
                      )
                    ],
                  ),
                  const SizedBox(height: 34),
                  FlatButtonLong(
                    title: 'Recover',
                    onPressed: () => BlocProvider.of<RecoverAccountTimerBloc>(context).add(const OnRecoverTapped()),
                    enabled: state.currentRemainingTime?.isZero == true,
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
