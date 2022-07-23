import 'package:flutter/material.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/no_guardian_widget.dart';

class MyGuardiansTab extends StatelessWidget {
  const MyGuardiansTab({super.key});

  @override
  Widget build(BuildContext context) {
    if (true) {
      return const NoGuardiansWidget(
        message: 'You haven’t added any Guardians yet. Add your first Guardian here.',
      );
    } else {
      final List<Widget> items = [];

      return Column(children: items);
    }
  }
}
