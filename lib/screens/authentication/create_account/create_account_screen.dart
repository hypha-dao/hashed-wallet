import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/authentication/create_account/create_account_name_screen.dart';
import 'package:seeds/screens/authentication/create_account/create_mnemonic_seed_screen.dart';
import 'package:seeds/screens/authentication/create_account/viewmodels/create_account_bloc.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateAccountBloc(),
      child: BlocConsumer<CreateAccountBloc, CreateAccountState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          // if (pageCommand is OnAccountCreated) {
          //   // BlocProvider.of<AuthenticationBloc>(context)
          //   //     .add(OnCreateAccount(account: state.accountName!, authData: pageCommand.authData));
          // } else if (pageCommand is ReturnToLogin) {
          //   NavigationService.of(context).pushAndRemoveAll(Routes.login); // return user to login
          // }
        },
        buildWhen: (previous, current) => previous.currentScreen != current.currentScreen,
        builder: (_, state) {
          final CreateAccountScreens signupScreens = state.currentScreen;
          switch (signupScreens) {
            case CreateAccountScreens.createName:
              return const CreateAccountNameScreen();
            case CreateAccountScreens.mnemonicSeed:
              return const CreateMnemonicSeedScreen();
          }
        },
      ),
    );
  }
}
