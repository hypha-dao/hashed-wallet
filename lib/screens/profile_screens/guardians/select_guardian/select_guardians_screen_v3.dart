import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_bloc.dart';

class SelectGuardiansScreenV3 extends StatelessWidget {
  const SelectGuardiansScreenV3({super.key});

  @override
  Widget build(BuildContext context) {
    final myGuardians = ModalRoute.of(context)?.settings.arguments as List<GuardianModel>?;

    return BlocProvider(
      create: (_) => SelectGuardiansBloc(myGuardians ?? []),
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4, left: horizontalEdgePadding, right: horizontalEdgePadding),
                      child: TextFormFieldCustom(labelText: 'Wallet Address'),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4, left: horizontalEdgePadding, right: horizontalEdgePadding),
                      child: TextFormFieldCustom(labelText: 'Add Nickname (Optional)'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                      child: FlatButtonLong(
                        title: 'Done',
                        onPressed: () {
                          /// Make call to add guardian
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
