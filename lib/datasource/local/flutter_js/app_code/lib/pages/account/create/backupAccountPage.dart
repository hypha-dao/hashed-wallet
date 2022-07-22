// @dart=2.9

import 'package:seeds/datasource/local/flutter_js/app_code/lib/pages/account/create/accountAdvanceOption.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/service/index.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/i18n/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_sdk/api/types/addressIconData.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/addressFormItem.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/button.dart';
import 'package:polkawallet_ui/components/v3/innerShadow.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class BackupAccountPage extends StatefulWidget {
  const BackupAccountPage(this.service);
  final AppService service;

  static final String route = '/account/backup';

  @override
  _BackupAccountPageState createState() => _BackupAccountPageState();
}

class _BackupAccountPageState extends State<BackupAccountPage> {
  AccountAdvanceOptionParams _advanceOptions = AccountAdvanceOptionParams();
  int _step = 0;

  List<String> _wordsSelected;
  List<String> _wordsLeft;

  AddressIconDataWithMnemonic _addressIcon = AddressIconDataWithMnemonic();

  Future<void> _generateAccount({String key = ''}) async {
    final addressInfo = await widget.service.plugin.sdk.api.keyring.generateMnemonic(widget.service.plugin.basic.ss58,
        cryptoType: _advanceOptions.type, derivePath: _advanceOptions.path, key: key);
    setState(() {
      _addressIcon = addressInfo;
    });

    if (key.isEmpty) {
      widget.service.store.account.setNewAccountKey(addressInfo.mnemonic);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateAccount();
    });
  }

  Widget _buildStep0(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'account');

    return Observer(
      builder: (_) {
        final mnemonics = widget.service.store.account.newAccount.key ?? '';
        return Scaffold(
          appBar: AppBar(title: Text(dic['create']), centerTitle: true, leading: BackBtn()),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Visibility(
                          visible: _addressIcon.svg != null,
                          child: AddressFormItem(
                              KeyPairData()
                                ..icon = _addressIcon.svg
                                ..address = _addressIcon.address,
                              isShowSubtitle: false)),
                      Container(
                        margin: EdgeInsets.only(top: 16.h),
                        child: Text(
                          dic['create.warn3'],
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.h, bottom: 12.h),
                        child: Text(dic['create.warn4']),
                      ),
                      InnerShadowBGCar(
                        child: Text(
                          mnemonics,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.h),
                        child: AccountAdvanceOption(
                          api: widget.service.plugin.sdk.api.keyring,
                          seed: mnemonics,
                          onChange: (data) {
                            setState(() {
                              _advanceOptions = data;
                            });

                            _generateAccount(key: mnemonics);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Button(
                    title: I18n.of(context).getDic(i18n_full_dic_ui, 'common')['next'],
                    onPressed: () {
                      final isKeyValid = mnemonics.split(' ').length == 12;
                      if ((_advanceOptions.error ?? false) || !isKeyValid) return;

                      setState(() {
                        _step = 1;
                        _wordsSelected = <String>[];
                        _wordsLeft = mnemonics.split(' ');
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep1(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'account');
    return Scaffold(
      appBar: AppBar(
          title: Text(dic['create']),
          leading: BackBtn(
            onBack: () {
              setState(() {
                _step = 0;
              });
            },
          )),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  Text(
                    dic['backup'],
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      dic['backup.confirm'],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            dic['backup.reset'],
                            style:
                                TextStyle(fontSize: UI.getTextSize(14, context), color: Theme.of(context).errorColor),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _wordsLeft = widget.service.store.account.newAccount.key.split(' ');
                            _wordsSelected = [];
                          });
                        },
                      )
                    ],
                  ),
                  InnerShadowBGCar(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                    child: Text(
                      _wordsSelected.join(' ') ?? '',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  _buildWordsButtons(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Button(
                title: I18n.of(context).getDic(i18n_full_dic_ui, 'common')['next'],
                onPressed: () {
                  if (_wordsSelected.join(' ') == widget.service.store.account.newAccount.key) {
                    Navigator.of(context).pop(_advanceOptions);
                  } else {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text(dic['import.warn']),
                          content: Text(dic['mnemonic.msg']),
                          actions: [
                            CupertinoButton(
                              child: Text(dic['mnemonic.btn']),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _wordsLeft = widget.service.store.account.newAccount.key.split(' ');
                                  _wordsSelected = [];
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordsButtons() {
    if (_wordsLeft.length > 0) {
      _wordsLeft.sort();
    }
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _wordsLeft.map((e) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _wordsLeft.remove(e);
                _wordsSelected.add(e);
              });
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(15.w, 4.h, 16.w, 5.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(image: AssetImage("assets/images/button_bg_red.png"), fit: BoxFit.fill),
              ),
              child: Text(
                e,
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: UI.getTextSize(16, context),
                  fontFamily: UI.getFontFamily('TitilliumWeb', context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case 0:
        return _buildStep0(context);
      case 1:
        return _buildStep1(context);
      default:
        return Container();
    }
  }
}
