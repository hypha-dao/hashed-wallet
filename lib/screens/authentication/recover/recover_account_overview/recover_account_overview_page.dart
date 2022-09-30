import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/authentication/recover/recover_account_overview/interactor/components/recover_account_overview_view.dart';
import 'package:hashed/screens/authentication/recover/recover_account_overview/interactor/viewmodels/recover_account_overview_bloc.dart';

class RecoverAccountOverviewPage extends StatelessWidget {
  const RecoverAccountOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecoverAccountOverviewBloc()..add(const FetchInitialData()),
      child: BlocListener<RecoverAccountOverviewBloc, RecoverAccountOverviewState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          if (pageCommand is NavigateToRouteWithArguments) {
            NavigationService.of(context).navigateTo(pageCommand.route, arguments: pageCommand.arguments);
          }
          if (pageCommand is NavigateToRoute) {
            NavigationService.of(context).navigateTo(pageCommand.route);
          }
        },
        child: BlocBuilder<RecoverAccountOverviewBloc, RecoverAccountOverviewState>(
            builder: (BuildContext context, RecoverAccountOverviewState state) {
          return Scaffold(
              appBar: AppBar(
                title: const Padding(padding: EdgeInsets.only(left: 16), child: Text("Recovery")),
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
                      onPressed: () =>
                          BlocProvider.of<RecoverAccountOverviewBloc>(context).add(const OnRefreshTapped()),
                    ),
                  )
                ],
              ),
              body: const RecoverAccountOverviewView());
        }),
      ),
    );
  }
}
