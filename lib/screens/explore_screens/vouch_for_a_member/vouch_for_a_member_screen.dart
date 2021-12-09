import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/search_user/search_user.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/user_citizenship_status.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/component/delegate_a_user_confirmation_dialog.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/component/delegate_a_user_success_dialog.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_page_commands.dart';

class VouchForAMemberScreen extends StatelessWidget {
  const VouchForAMemberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DelegateAUserBloc(),
      child: BlocConsumer<DelegateAUserBloc, DelegateAUserState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;

          if (pageCommand is ShowDelegateConfirmation) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return BlocProvider.value(
                  value: BlocProvider.of<DelegateAUserBloc>(context),
                  child: DelegateAUserConfirmationDialog(pageCommand.selectedDelegate),
                );
              },
            );
          } else if (pageCommand is ShowDelegateUserSuccess) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return BlocProvider.value(
                  value: BlocProvider.of<DelegateAUserBloc>(context),
                  child: const DelegateAUserSuccessDialog(),
                );
              },
            );
          } else if (pageCommand is ShowErrorMessage) {
            SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
          }
          BlocProvider.of<DelegateAUserBloc>(context).add(const ClearPageCommand());
        },
        builder: (context, DelegateAUserState state) {
          switch (state.pageState) {
            case PageState.loading:
              return const Scaffold(body: FullPageLoadingIndicator());
            case PageState.failure:
              return const FullPageErrorIndicator();
            case PageState.success:
              return Scaffold(
                appBar: AppBar(title: const Text("Delegate A User")),
                body: Column(
                  children: [
                    Expanded(
                      child: SearchUser(
                        filterByCitizenshipStatus: UserCitizenshipStatus.citizen,
                        noShowUsers: state.noShowUsers,
                        title: "Citizens",
                        resultCallBack: (selectedUser) {
                          BlocProvider.of<DelegateAUserBloc>(context).add(OnUserSelected(selectedUser));
                        },
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
