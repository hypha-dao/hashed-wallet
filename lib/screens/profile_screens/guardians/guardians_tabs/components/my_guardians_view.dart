import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/components/no_guardian_widget.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';
import 'package:hashed/utils/ThemeBuildContext.dart';
import 'package:hashed/utils/short_string.dart';

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
                  e.name ?? e.address.shorter,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
                subtitle: e.name != null
                    ? Text(
                        e.address,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      )
                    : null,
                trailing: state.areGuardiansActive
                    ? Icon(Icons.check_circle, color: context.colorScheme.onBackground)
                    : TextButton(
                        onPressed: () {
                          BlocProvider.of<GuardiansBloc>(context).add(OnRemoveGuardianTapped(e));
                        },
                        child: Text(
                          state.areGuardiansActive ? '' : 'Remove',
                          style: TextStyle(color: context.colorScheme.secondary),
                        )),
              )));

          if (state.myGuardians.length <= 9 && !state.areGuardiansActive) {
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
