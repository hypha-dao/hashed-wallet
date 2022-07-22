// @dart=2.9

import 'package:seeds/datasource/local/flutter_js/app_code/lib/pages/account/create/createAccountPage.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/i18n/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/button.dart';

import 'import/selectImportTypePage.dart';

class CreateAccountEntryPage extends StatelessWidget {
  CreateAccountEntryPage(this.plugin);

  static final String route = '/account/entry';

  final PolkawalletPlugin plugin;

  void _checkJsCodeStarted(BuildContext context) {
    if (plugin.sdk.webView.webViewLoaded) {
      if (plugin.sdk.webView.jsCodeStarted == 0) {
        showCupertinoDialog(
            context: context,
            builder: (_) {
              return CupertinoAlertDialog(
                content: Text(I18n.of(context).getDic(i18n_full_dic_app, 'public')['os.invalid']),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkJsCodeStarted(context);
    });
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'account');
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // appBar: AppBar(title: Text(dic['add']), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Image.asset('assets/images/icon.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Button(
                title: dic['create'],
                isBlueBg: true,
                onPressed: () {
                  Navigator.pushNamed(context, CreateAccountPage.route);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Button(
                title: dic['import'],
                isBlueBg: true,
                onPressed: () {
                  Navigator.pushNamed(context, SelectImportTypePage.route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
