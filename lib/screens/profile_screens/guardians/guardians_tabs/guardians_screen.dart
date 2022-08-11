import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/datasource/remote/model/guardians_config_model.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/components/activate_guardians_confirmation_dialog.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/components/my_guardians_view.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/components/reset_guardians_confirmation_dialog.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';

class GuardiansScreen extends StatelessWidget {
  const GuardiansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GuardiansBloc()..add(Initial()),
      child: BlocListener<GuardiansBloc, GuardiansState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<GuardiansBloc>(context).add(const ClearPageCommand());

          if (pageCommand is ShowResetGuardians) {
            _showResetGuardiansDialog(context);
          } else if (pageCommand is ShowActivateGuardians) {
            _showActivateDialog(context, state.myGuardians);
          } else if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          }
        },
        child: BlocBuilder<GuardiansBloc, GuardiansState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text("My Guardians"),
              ),
              bottomNavigationBar: state.pageState == PageState.loading
                  ? const SizedBox.shrink()
                  : SafeArea(
                      minimum: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                      child: FlatButtonLong(
                        title: state.actionButtonState.title,
                        isLoading: state.actionButtonState.isLoading,
                        enabled: state.actionButtonState.isEnabled,
                        onPressed: () {
                          BlocProvider.of<GuardiansBloc>(context).add(OnMyGuardianActionButtonTapped());
                        },
                      ),
                    ),
              body: state.pageState == PageState.loading
                  ? const FullPageLoadingIndicator()
                  : const SafeArea(child: MyGuardiansView()),
            );
          },
        ),
      ),
    );
  }
}

void _showResetGuardiansDialog(BuildContext buildContext) {
  showDialog(
    context: buildContext,
    builder: (context) {
      return ResetGuardiansConfirmationDialog(
        onConfirm: () {
          BlocProvider.of<GuardiansBloc>(buildContext).add(OnResetConfirmed());
          Navigator.pop(context);
        },
        onDismiss: () => Navigator.pop(context),
      );
    },
  );
}

void _showActivateDialog(BuildContext buildContext, GuardiansConfigModel guards) {
  showDialog(
    context: buildContext,
    builder: (context) {
      return ActivateGuardiansConfirmationDialog(
        onConfirm: () {
          BlocProvider.of<GuardiansBloc>(buildContext).add(OnActivateConfirmed(guards));
          Navigator.pop(context);
        },
        onDismiss: () => Navigator.pop(context),
      );
    },
  );
}
