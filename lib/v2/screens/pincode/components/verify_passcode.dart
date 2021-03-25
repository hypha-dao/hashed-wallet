import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/passcode.i18n.dart';
import 'package:seeds/v2/screens/pincode/interactor/viewmodels/bloc.dart';

class VerifyPasscode extends StatelessWidget {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasscodeBloc, PasscodeState>(
      listenWhen: (previous, current) => previous.isValidPasscode != current.isValidPasscode,
      listener: (context, state) => _verificationNotifier.add(state.isValidPasscode),
      child: PasscodeScreen(
        cancelButton: const SizedBox.shrink(),
        deleteButton: Text('Delete'.i18n, style: Theme.of(context).textTheme.subtitle2),
        passwordDigits: 4,
        title: Text('Re-enter Pincode'.i18n, style: Theme.of(context).textTheme.subtitle2),
        backgroundColor: AppColors.primary,
        shouldTriggerVerification: _verificationNotifier.stream,
        passwordEnteredCallback: (passcode) =>
            BlocProvider.of<PasscodeBloc>(context).add(OnVerifyPasscode(passcode: passcode)),
        isValidCallback: () => BlocProvider.of<PasscodeBloc>(context).add(const OnValidPasscode()),
        bottomWidget: const SizedBox.shrink(),
        circleUIConfig: const CircleUIConfig(circleSize: 14),
      ),
    );
  }
}
