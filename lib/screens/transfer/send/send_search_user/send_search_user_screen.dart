import 'package:flutter/material.dart';
import 'package:hashed/components/search_user/search_user.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/utils/build_context_extension.dart';

class SendSearchUserScreen extends StatelessWidget {
  const SendSearchUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.transferSendSearchTitle)),
      body: SearchUser(
        noShowUsers: [accountService.currentAccount.address],
        onUserSelected: (selectedUser) {
          print('SendSearchUserScreen - onUserSelected: ${selectedUser.account}');
          NavigationService.of(context).navigateTo(Routes.sendEnterData, selectedUser);
        },
      ),
    );
  }
}
