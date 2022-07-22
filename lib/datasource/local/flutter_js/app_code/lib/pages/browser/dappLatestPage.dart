// @dart=2.9
import 'package:seeds/datasource/local/flutter_js/app_code/lib/pages/browser/browserApi.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/service/index.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/i18n/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_plugin_karura/utils/i18n/index.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/plugin/PluginIconButton.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginScaffold.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/index.dart';

class DappLatestPage extends StatefulWidget {
  DappLatestPage(this.service, {Key key}) : super(key: key);
  final AppService service;

  static final String route = '/browser/latest';

  @override
  State<DappLatestPage> createState() => _DappLatestPageState();
}

class _DappLatestPageState extends State<DappLatestPage> {
  bool _isdelete = false;

  Future<bool> _showCupertinoDialog(String message) async {
    final bool res = await showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(I18n.of(context).getDic(i18n_full_dic_karura, 'common')['cancel']),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                child: Text(I18n.of(context).getDic(i18n_full_dic_karura, 'common')['ok']),
                onPressed: () => Navigator.of(context).pop(true),
              )
            ],
          );
        });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)?.getDic(i18n_full_dic_app, 'public');
    final dappLatests = BrowserApi.getDappLatest(widget.service);
    return WillPopScope(
        onWillPop: () {
          if (_isdelete) {
            Navigator.of(context).pop(true);
          } else {
            Navigator.of(context).pop();
          }
          return Future.value();
        },
        child: PluginScaffold(
            appBar: PluginAppBar(
              title: Text(dic['hub.browser.latest']),
              centerTitle: true,
              leading: PluginIconButton(
                icon: SvgPicture.asset(
                  "packages/polkawallet_ui/assets/images/icon_back_24.svg",
                  color: Colors.black,
                ),
                onPressed: () {
                  if (_isdelete) {
                    Navigator.of(context).pop(true);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            body: SafeArea(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              final bool res = await _showCupertinoDialog(dic['hub.browser.clearAllMessage']);
                              if (res) {
                                BrowserApi.deleteAllLatest(widget.service);
                                setState(() {
                                  _isdelete = true;
                                });
                              }
                            },
                            child: Container(
                                child: Text(
                                  dic['hub.browser.clearAll'],
                                  style: Theme.of(context).textTheme.headline5?.copyWith(
                                      fontSize: UI.getTextSize(12, context),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                    color: PluginColorsDark.primary, borderRadius: BorderRadius.circular(6)))),
                        Expanded(
                            child: ListView.separated(
                                padding: EdgeInsets.only(top: 16),
                                separatorBuilder: (context, index) => Container(height: 8),
                                itemCount: dappLatests.length,
                                itemBuilder: (context, index) {
                                  final e = dappLatests[index];
                                  return Slidable(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: PluginColorsDark.cardColor, borderRadius: BorderRadius.circular(4)),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 32,
                                                height: 32,
                                                margin: EdgeInsets.only(right: 10),
                                                child: (e["icon"] as String).contains('.svg')
                                                    ? SvgPicture.network(e["icon"])
                                                    : Image.network(e["icon"])),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e["name"],
                                                  style: Theme.of(context).textTheme.headline5?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      color: PluginColorsDark.headline1,
                                                      height: 1.0),
                                                ),
                                                Text(e["detailUrl"],
                                                    style: Theme.of(context).textTheme.headline6?.copyWith(
                                                        fontSize: UI.getTextSize(10, context),
                                                        color: PluginColorsDark.green))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      endActionPane: ActionPane(
                                        extentRatio: 0.12,
                                        motion: ScrollMotion(),
                                        children: [
                                          Expanded(
                                              child: GestureDetector(
                                                  onTap: () async {
                                                    final bool res =
                                                        await _showCupertinoDialog(dic['hub.browser.clearMessage']);
                                                    if (res) {
                                                      BrowserApi.deleteLatest(e, widget.service);
                                                      setState(() {
                                                        _isdelete = true;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 2),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                                      color: PluginColorsDark.primary,
                                                    ),
                                                    child: Center(
                                                      child: Icon(Icons.delete_outline, color: Colors.black),
                                                    ),
                                                  ))),
                                        ],
                                      ));
                                }))
                      ],
                    )))));
  }
}
