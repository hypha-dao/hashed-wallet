import 'package:flutter/material.dart';
import 'package:hashed/components/profile_avatar.dart';
import 'package:hashed/datasource/local/models/account.dart';

class GuardianRowWidget extends StatelessWidget {
  final Account guardianModel;
  final bool showGuardianSigned;

  const GuardianRowWidget({
    super.key,
    required this.guardianModel,
    required this.showGuardianSigned,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        trailing: showGuardianSigned ? const Icon(Icons.check_circle) : const SizedBox.shrink(),
        leading: ProfileAvatar(
          size: 60,
          // ignore: avoid_redundant_argument_values
          image: null,
          account: guardianModel.address,
          nickname: guardianModel.name,
        ),
        title: Text(
          guardianModel.name != null ? guardianModel.name! : guardianModel.address,
          style: Theme.of(context).textTheme.button,
        ),
        subtitle: Text(guardianModel.name != null ? guardianModel.address : ""),
        onTap: () {});
  }
}
