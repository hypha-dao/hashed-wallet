import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/no_guardian_widget.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';

class MyGuardiansTab extends StatelessWidget {
  const MyGuardiansTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuardiansBloc, GuardiansState>(
      builder: (context, state) {
        if (true) {
          return NoGuardiansWidget(
            message: 'You haven’t added any Guardians yet. Add your first Guardian here.',
            onPressed: () {
              BlocProvider.of<GuardiansBloc>(context).add(OnAddGuardiansTapped());
            },
          );
        } else {
          final List<Widget> items = [];

          return Column(children: items);
        }
      },
    );
  }
}
