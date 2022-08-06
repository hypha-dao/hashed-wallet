import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/profile_screens/export_private_key/interactor/viewmodels/export_private_key_bloc.dart';
import 'package:seeds/screens/profile_screens/export_private_key/interactor/viewmodels/export_private_key_page_commands.dart';
import 'package:share/share.dart';

class ExportPrivateKeyScreen extends StatelessWidget {
  const ExportPrivateKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Export Secret Words")),
      body: BlocProvider(
        create: (_) => ExportPrivateKeyBloc()..add(const LoadSecretWords()),
        child: BlocListener<ExportPrivateKeyBloc, ExportPrivateKeyState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;

            if (pageCommand is ShowSharePrivateKey) {
              Share.share(state.privateWords);
            }
            BlocProvider.of<ExportPrivateKeyBloc>(context).add(const ClearPageCommand());
          },
          child: SafeArea(
            minimum: const EdgeInsets.all(horizontalEdgePadding),
            child: Builder(
              builder: (context) {
                return BlocBuilder<ExportPrivateKeyBloc, ExportPrivateKeyState>(
                  buildWhen: (previous, current) => previous.pageState != current.pageState,
                  builder: (context, state) {
                    return Column(
                      children: [
                        TextFormFieldCustom(
                          suffixIcon: state.pageState == PageState.loading
                              ? const Center(child: CircularProgressIndicator())
                              : null,
                          controller: TextEditingController(text: state.privateWords),
                          enabled: false,
                          maxLines: 2,
                          labelText: "Secret Words",
                        ),
                        const Spacer(),
                        FlatButtonLong(
                          isLoading: state.pageState == PageState.loading,
                          title: "Export",
                          onPressed: () {
                            BlocProvider.of<ExportPrivateKeyBloc>(context).add(const OnExportButtonTapped());
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
