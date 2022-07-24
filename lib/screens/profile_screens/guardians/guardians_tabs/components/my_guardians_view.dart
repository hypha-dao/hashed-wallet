import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              BlocProvider.of<GuardiansBloc>(context).add(OnAddGuardiansTapped());
            },
          );
        } else {
          return ListView(
            children: state.myGuardians
                .map((e) => ListTile(
                      title: Text(
                        e.nickname ?? e.walletAddress,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      trailing: TextButton(
                          child: const Text('Remove'),
                          onPressed: () {
                            BlocProvider.of<GuardiansBloc>(context).add(OnRemoveGuardianTapped(e));
                          }),
                    ))
                .toList(),
          );
        }
      },
    );
  }
}
