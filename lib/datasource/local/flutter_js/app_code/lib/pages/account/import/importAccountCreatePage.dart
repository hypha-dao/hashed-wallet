// @dart=2.9
import 'package:seeds/datasource/local/flutter_js/app_code/lib/pages/account/create/createAccountForm.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/service/index.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/i18n/index.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/back.dart';

import 'importAccountAction.dart';

class ImportAccountCreatePage extends StatefulWidget {
  final AppService service;

  static final String route = '/account/ImportAccountCreatePage';

  ImportAccountCreatePage(this.service, {Key key}) : super(key: key);

  @override
  _ImportAccountCreatePageState createState() => _ImportAccountCreatePageState();
}

class _ImportAccountCreatePageState extends State<ImportAccountCreatePage> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'account');
    final data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text(dic['import']), centerTitle: true, leading: BackBtn()),
      body: SafeArea(
        child: CreateAccountForm(
          widget.service,
          submitting: _submitting,
          onSubmit: () {
            return ImportAccountAction.onSubmit(context, widget.service, data, (submitting) {
              setState(() {
                this._submitting = submitting;
              });
            });
          },
        ),
      ),
    );
  }
}
