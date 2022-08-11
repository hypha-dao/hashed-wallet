import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/text_form_field_custom.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/page_commands.dart';
import 'package:hashed/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_bloc.dart';

class SelectGuardiansScreenV3 extends StatelessWidget {
  const SelectGuardiansScreenV3({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectGuardiansBloc(),
      child: BlocListener<SelectGuardiansBloc, SelectGuardiansState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          if (state.pageCommand is ShowMaxUserCountSelected) {
            eventBus.fire(ShowSnackBar((state.pageCommand! as ShowMaxUserCountSelected).message));
          }

          BlocProvider.of<SelectGuardiansBloc>(context).add(const ClearPageCommand());
        },
        child: BlocBuilder<SelectGuardiansBloc, SelectGuardiansState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: const Text('Enter Guardian Address')),
              body: SafeArea(
                minimum: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 4, left: horizontalEdgePadding, right: horizontalEdgePadding),
                      child: TextFormFieldCustom(
                          labelText: 'Wallet Address',
                          initialValue: state.guardianKey,
                          onChanged: (value) {
                            BlocProvider.of<SelectGuardiansBloc>(context).add(OnKeyChanged(value));
                          }),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 4, left: horizontalEdgePadding, right: horizontalEdgePadding),
                      child: TextFormFieldCustom(
                          labelText: 'Add Nickname (Optional)',
                          initialValue: state.guardianName,
                          onChanged: (value) {
                            BlocProvider.of<SelectGuardiansBloc>(context).add(OnNameChanged(value));
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                      child: FlatButtonLong(
                        title: 'Done',
                        isLoading: state.isActionButtonLoading,
                        enabled: state.isActionButtonEnabled,
                        onPressed: () {
                          /// Make call to add guardian
                          Navigator.of(context).pop(
                            Account(address: state.guardianKey!, name: state.guardianName),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
