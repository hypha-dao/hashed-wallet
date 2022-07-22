// @dart=2.9
import 'package:seeds/datasource/local/flutter_js/app_code/lib/pages/account/import/importAccountFormKeyStore.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/pages/account/import/importAccountFromRawSeed.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/pages/profile/index.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/service/index.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/i18n/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';

import 'importAccountFormMnemonic.dart';

class SelectImportTypePage extends StatefulWidget {
  static final String route = '/account/selectImportType';
  final AppService service;

  SelectImportTypePage(this.service, {Key key}) : super(key: key);

  @override
  _SelectImportTypePageState createState() => _SelectImportTypePageState();
}

class _SelectImportTypePageState extends State<SelectImportTypePage> {
  final _keyOptions = [
    'mnemonic',
    'rawSeed',
    'keystore',
  ];

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'account');
    return Scaffold(
      appBar: AppBar(title: Text(dic['import']), centerTitle: true, leading: BackBtn()),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(title: Text(dic['import.type'])),
              RoundedCard(
                  margin: EdgeInsets.only(left: 15.w, right: 15.w),
                  padding: EdgeInsets.all(8),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 12.h, bottom: 12.h),
                          child: SettingsPageListItem(
                            label: dic[_keyOptions[index]],
                            onTap: () {
                              switch (_keyOptions[index]) {
                                case 'mnemonic':
                                  Navigator.pushNamed(context, ImportAccountFormMnemonic.route,
                                      arguments: {"type": _keyOptions[index]});
                                  break;
                                case 'rawSeed':
                                  Navigator.pushNamed(context, ImportAccountFromRawSeed.route,
                                      arguments: {"type": _keyOptions[index]});
                                  break;
                                case 'keystore':
                                  Navigator.pushNamed(context, ImportAccountFormKeyStore.route,
                                      arguments: {"type": _keyOptions[index]});
                                  break;
                              }
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemCount: _keyOptions.length)),
            ],
          ),
        ),
      ),
    );
  }
}
