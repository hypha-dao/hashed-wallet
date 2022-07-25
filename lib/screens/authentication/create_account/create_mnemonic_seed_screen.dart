import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/authentication/create_account/viewmodels/create_account_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class CreateMnemonicSeedScreen extends StatelessWidget {
  const CreateMnemonicSeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CreateMnemonicSeedScreen")),
      body: BlocConsumer<CreateAccountBloc, CreateAccountState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;

          // if (pageCommand is EditNameSuccess) {
          //   Navigator.of(context).pop(state.name);
          // } else
          if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
            BlocProvider.of<CreateAccountBloc>(context).add(const ClearPageCommand());
          }
        },
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.initial:
            case PageState.loading:
            case PageState.failure:
              return SafeArea(
                minimum: const EdgeInsets.all(horizontalEdgePadding),
                child: Form(
                  child: Column(
                    children: [
                      TextFormFieldCustom(
                        maxLength: 21,
                        initialValue: state.name,
                        labelText: context.loc.editNameLabel,
                        onFieldSubmitted: (_) {
                          //  BlocProvider.of<EditNameBloc>(context).add(const SubmitName());
                        },
                        onChanged: (String value) {
                          //  BlocProvider.of<EditNameBloc>(context).add(OnNameChanged(name: value));
                        },
                        errorText: state.errorMessage,
                      ),
                      const Text(
                          "Your name is just for your own reference and will not be displayed in any public domains unless specified."),
                      const Spacer(),
                      FlatButtonLong(
                        isLoading: state.pageState == PageState.loading,
                        // enabled: state.isSubmitEnabled,
                        title: "Next (1/2)",
                        onPressed: () {
                          //    BlocProvider.of<EditNameBloc>(context).add(const SubmitName());
                        },
                      )
                    ],
                  ),
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
