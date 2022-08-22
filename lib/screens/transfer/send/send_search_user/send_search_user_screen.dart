import 'package:flutter/material.dart';
import 'package:hashed/components/search_user/search_user.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/utils/build_context_extension.dart';

class SendSearchUserScreen extends StatelessWidget {
  const SendSearchUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.transferSendSearchTitle)),
      body: SearchUser(
        onUserSelected: (selectedUser) {
          print('[TBD] SendSearchUserScreen - onUserSelected: ${selectedUser.address} name: ${selectedUser.name}');
          //NavigationService.of(context).navigateTo(Routes.sendEnterData, selectedUser);
        },
      ),
    );
  }
}
