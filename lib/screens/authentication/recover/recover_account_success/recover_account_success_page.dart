import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/screens/authentication/recover/recover_account_success/components/recover_account_success_view.dart';
import 'package:hashed/screens/authentication/recover/recover_account_success/interactor/viewmodels/recover_account_success_bloc.dart';

class RecoverAccountSuccessPage extends StatelessWidget {
  const RecoverAccountSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: cast_nullable_to_non_nullable
    final String userAccount = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (context) => RecoverAccountSuccessBloc(userAccount)..add(const FetchInitialData()),
      child: Scaffold(
          appBar: AppBar(
            title: const Padding(padding: EdgeInsets.only(left: 16), child: Text("Recover Account")),
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          body: const RecoverAccountSuccessView()),
    );
  }
}
