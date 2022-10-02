import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/text_form_field_custom.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/authentication/import_key/interactor/viewmodels/import_key_bloc.dart';

class ImportKeyScreen extends StatelessWidget {
  final textController = TextEditingController();

  ImportKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImportKeyBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Import Account")),
        body: BlocListener<ImportKeyBloc, ImportKeyState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;

            if (pageCommand is NavigateToRouteWithArguments) {
              NavigationService.of(context).navigateTo(pageCommand.route, arguments: pageCommand.arguments);
            } else if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            }
            BlocProvider.of<ImportKeyBloc>(context).add(const ClearPageCommand());
          },
          child: Builder(
            builder: (context) {
              return SafeArea(
                minimum: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                      child: Column(
                        children: [
                          BlocBuilder<ImportKeyBloc, ImportKeyState>(
                            buildWhen: (previous, current) {
                              return previous.mnemonicPhrase != current.mnemonicPhrase ||
                                  previous.error != current.error;
                            },
                            builder: (context, state) {
                              return TextFormFieldCustom(
                                controller: textController,
                                maxLines: 2,
                                autofocus: true,
                                labelText: "Your Secret Words",
                                hintText: "Enter your secret words",
                                errorText: state.error,
                                errorMaxLines: 10,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.paste),
                                  onPressed: () async {
                                    final clipboardData = await Clipboard.getData('text/plain');
                                    final clipboardText = clipboardData?.text ?? '';
                                    textController.text = clipboardText;
                                    // ignore: use_build_context_synchronously
                                    BlocProvider.of<ImportKeyBloc>(context).add(OnMnemonicPhraseChange(
                                      newMnemonicPhrase: clipboardText,
                                    ));
                                  },
                                ),
                                onChanged: (value) {
                                  BlocProvider.of<ImportKeyBloc>(context)
                                      .add(OnMnemonicPhraseChange(newMnemonicPhrase: value));
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: BlocBuilder<ImportKeyBloc, ImportKeyState>(
                          buildWhen: (previous, current) {
                            return previous.isButtonLoading != current.isButtonLoading ||
                                previous.enableButton != current.enableButton;
                          },
                          builder: (context, state) {
                            return FlatButtonLong(
                              enabled: state.enableButton,
                              isLoading: state.isButtonLoading,
                              title: "Next (1/2)",
                              onPressed: () => {BlocProvider.of<ImportKeyBloc>(context).add(const GetAccountByKey())},
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
