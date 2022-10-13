import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/authentication/recover/recover_account_details/interactor/usecase/fetch_recover_account_details_data.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/components/recover_account_timer_view.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/components/recover_success_dialog.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/viewmodels/recover_account_timer_bloc.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/viewmodels/recover_account_timer_page_command.dart';

class RecoverAccountTimerPage extends StatelessWidget {
  const RecoverAccountTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: cast_nullable_to_non_nullable
    final RecoveryResultData recoveryData = ModalRoute.of(context)!.settings.arguments as RecoveryResultData;
    return BlocProvider(
        create: (context) => RecoverAccountTimerBloc(recoveryData.activeRecovery, recoveryData.configuration)
          ..add(const FetchTimerData(true)),
        child: BlocListener<RecoverAccountTimerBloc, RecoverAccountTimerState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;

            if (pageCommand is OnRecoverSuccessPageCommand) {
              _showSuccessDialog(context, state.recoveryModel.lostAccount);
            }

            // TODO(n13): clear page command?
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Padding(padding: EdgeInsets.only(left: 16), child: Text("Recover Account")),
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            body: const RecoverAccountTimerView(),
          ),
        ));
  }

  void _showSuccessDialog(BuildContext buildContext, String lostAccount) {
    showDialog(
      context: buildContext,
      builder: (context) {
        return RecoverSuccessDialog(
          onDismiss: () {
            Navigator.popUntil(context, (route) => route.settings.name == Routes.recoverAccountOverview);
            NavigationService.of(context).navigateTo(Routes.recoverAccountSuccess, arguments: lostAccount);
            eventBus.fire(const OnRecoverDataChangedEventBus());
          },
        );
      },
    );
  }
}
