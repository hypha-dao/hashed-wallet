import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/text_form_field_custom.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/authentication/recover/recover_account_overview/interactor/viewmodels/recover_account_overview_bloc.dart';
import 'package:hashed/screens/authentication/recover/recover_account_search/components/recover_account_confimation_dialog.dart';
import 'package:hashed/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_page_command.dart';
import 'package:hashed/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_search_bloc.dart';

class RecoverAccountScreen extends StatefulWidget {
  const RecoverAccountScreen({super.key});

  @override
  State<RecoverAccountScreen> createState() => _RecoverAccountScreenState();
}

class _RecoverAccountScreenState extends State<RecoverAccountScreen> {
  final TextEditingController _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _keyController.text = '';
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecoverAccountSearchBloc(accountService, polkadotRepository),
      child: BlocConsumer<RecoverAccountSearchBloc, RecoverAccountSearchState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<RecoverAccountSearchBloc>(context).add(const ClearPageCommand());
          if (pageCommand is ShowRecoverAccountConfirmation) {
            _showRecoverConfirmationDialog(context, pageCommand.userAccount);
          } else if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          } else if (pageCommand is NavigateToRouteWithArguments) {
            BlocProvider.of<RecoverAccountOverviewBloc>(context).add(const OnRefreshTapped());
            NavigationService.of(context).navigateTo(
              pageCommand.route,
              arguments: pageCommand.arguments,
              replace: true,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Initiate Recovery"),
            ),
            body: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormFieldCustom(
                          maxLines: 2,
                          labelText: "Enter Account Address",
                          controller: _keyController,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.paste),
                            onPressed: () async {
                              final clipboardData = await Clipboard.getData('text/plain');
                              final clipboardText = clipboardData?.text ?? '';
                              _keyController.text = clipboardText;
                              // ignore: use_build_context_synchronously
                              BlocProvider.of<RecoverAccountSearchBloc>(context).add(OnAccountChanged(clipboardText));
                            },
                          ),
                          onChanged: (value) {
                            BlocProvider.of<RecoverAccountSearchBloc>(context).add(OnAccountChanged(value));
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButtonLong(
                      title: "Next",
                      enabled: state.isNextEnabled,
                      isLoading: state.isNextLoading,
                      onPressed: () =>
                          BlocProvider.of<RecoverAccountSearchBloc>(context).add(const OnNextButtonTapped()),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRecoverConfirmationDialog(BuildContext buildContext, String lostAccount) {
    showDialog(
      context: buildContext,
      builder: (context) {
        return RecoverAccountConfirmationDialog(
          account: lostAccount,
          onConfirm: () {
            BlocProvider.of<RecoverAccountSearchBloc>(buildContext).add(const OnConfirmRecoverTapped());
            Navigator.pop(context);
          },
          onDismiss: () => Navigator.pop(context),
        );
      },
    );
  }
}
