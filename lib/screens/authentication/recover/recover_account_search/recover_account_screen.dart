import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/quadstate_clipboard_icon_button.dart';
import 'package:hashed/components/text_form_field_custom.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/navigation/navigation_service.dart';
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
      create: (_) => RecoverAccountSearchBloc(),
      child: BlocConsumer<RecoverAccountSearchBloc, RecoverAccountSearchState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          if (pageCommand is NavigateToRecoverAccountFound) {
            NavigationService.of(context).navigateTo(Routes.recoverAccountFound, pageCommand.userAccount);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Recover Account"),
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
                          suffixIcon: QuadStateClipboardIconButton(
                            isChecked: false,
                            onClear: () {
                              BlocProvider.of<RecoverAccountSearchBloc>(context).add(const OnAccountChanged(''));
                              _keyController.clear();
                            },
                            isLoading: false,
                            canClear: _keyController.text.isNotEmpty,
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
}
