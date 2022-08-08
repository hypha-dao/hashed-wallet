import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/local/models/account.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/no_guardian_widget.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';

class MyGuardiansView extends StatelessWidget {
  const MyGuardiansView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuardiansBloc, GuardiansState>(
      builder: (context, state) {
        if (state.myGuardians.isEmpty) {
          return NoGuardiansWidget(
            message: 'You haven’t added any Guardians yet. Add your first Guardian here.',
            onPressed: () {
              NavigationService.of(context)
                  .navigateTo(Routes.selectGuardians)
                  .then((value) => _onAddGuardianResult(value, context));
            },
          );
        } else {
          final List<ListTile> items = [];
          items.addAll(state.myGuardians.guardians.map((e) => ListTile(
                title: Text(
                  e.name ?? e.address,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
                subtitle: e.name != null
                    ? Text(
                        e.address,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      )
                    : null,
                trailing: TextButton(
                    child: Text(state.areGuardiansActive ? 'active' : 'Remove'),
                    onPressed: () {
                      if (!state.areGuardiansActive) {
                        BlocProvider.of<GuardiansBloc>(context).add(OnRemoveGuardianTapped(e));
                      }
                    }),
              )));

          if (state.myGuardians.length < 3 && !state.myGuardians.areGuardiansActive) {
            items.add(ListTile(
                title: const Text('Add Guardian'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    NavigationService.of(context)
                        .navigateTo(Routes.selectGuardians)
                        .then((value) => _onAddGuardianResult(value, context));
                  },
                ),
                onTap: () {
                  NavigationService.of(context)
                      .navigateTo(Routes.selectGuardians)
                      .then((value) => _onAddGuardianResult(value, context));
                }));
          }
          return ListView(children: items);
        }
      },
    );
  }

  void _onAddGuardianResult(Account? value, BuildContext context) {
    if (value != null) {
      BlocProvider.of<GuardiansBloc>(context).add(OnGuardianAdded(value));
    }
  }
}
