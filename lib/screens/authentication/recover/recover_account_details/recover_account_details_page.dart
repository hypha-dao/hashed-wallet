import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/screens/authentication/recover/recover_account_details/interactor/components/recover_account_details_view.dart';
import 'package:hashed/screens/authentication/recover/recover_account_details/interactor/viewmodels/recover_account_details_bloc.dart';

class RecoverAccountDetailsPage extends StatelessWidget {
  const RecoverAccountDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: cast_nullable_to_non_nullable
    final String userAccount = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (context) => RecoverAccountDetailsBloc(userAccount)..add(const FetchInitialData()),
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
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => BlocProvider.of<RecoverAccountDetailsBloc>(context).add(const OnRefreshTapped()),
                ),
              )
            ],
          ),
          body: const RecoverAccountDetailsView()),
    );
  }
}
