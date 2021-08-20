import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/profile/components/profile_bottom.dart';
import 'package:seeds/screens/profile_screens/profile/components/profile_header.dart';
import 'package:seeds/screens/profile_screens/profile/components/profile_middle.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';

/// PROFILE SCREEN
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        create: (_) => ProfileBloc()..add(LoadProfileValues()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(settingsStorage.accountName),
            actions: [
              IconButton(
                icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg'),
                onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
              ),
            ],
          ),
          body: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) => RefreshIndicator(
                    onRefresh: () async {
                      print("refresh... profile");
                      BlocProvider.of<ProfileBloc>(context).add(LoadProfileValues());
                    },
                    child: ListView(
                      children: [
                        const ProfileHeader(),
                        const DividerJungle(thickness: 2),
                        const ProfileMiddle(),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16), child: DividerJungle(thickness: 2)),
                        const ProfileBottom(),
                      ],
                    ),
                  )),
        ));
  }
}