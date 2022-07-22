// @dart=2.9
import 'package:seeds/datasource/local/flutter_js/app_code/lib/app.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/pages/profile/index.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/service/index.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/service/walletApi.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/UI.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/Utils.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/i18n/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AboutPage extends StatefulWidget {
  AboutPage(this.service);

  final AppService service;

  static final String route = '/profile/about';

  @override
  _AboutPage createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  bool _updateLoading = false;
  String _appVersion;

  Future<void> _checkUpdate({bool autoCheck = false}) async {
    if (_updateLoading) return;

    setState(() {
      _updateLoading = true;
    });
    final versions = await WalletApi.getLatestVersion();
    setState(() {
      _updateLoading = false;
    });
    AppUI.checkUpdate(context, versions, WalletApp.buildTarget, autoCheck: autoCheck);
  }

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    _checkUpdate(autoCheck: true);
  }

  _getAppVersion() async {
    var appVersion = await Utils.getAppVersion();
    setState(() {
      _appVersion = appVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'profile');
    final currentJSVersion = WalletApi.getPolkadotJSVersion(
        widget.service.store.storage, widget.service.plugin.basic.name, widget.service.plugin.basic.jsCodeVersion);
    final colorGray = Theme.of(context).unselectedWidgetColor;
    final contentStyle = TextStyle(fontSize: UI.getTextSize(14, context), color: colorGray);

    final pagePadding = 16.w;
    return Scaffold(
      appBar: AppBar(title: Text(dic['about.title']), centerTitle: true, leading: BackBtn()),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              RoundedCard(
                margin: EdgeInsets.fromLTRB(pagePadding, 4.h, pagePadding, 16.h),
                padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
                child: Column(
                  children: [
                    SettingsPageListItem(
                      label: dic['about.terms'],
                      onTap: () => UI.launchURL('https://polkawallet.io/terms-conditions.html'),
                    ),
                    Divider(height: 24.h),
                    SettingsPageListItem(
                      label: dic['about.privacy'],
                      onTap: () => UI.launchURL('https://github.com/polkawallet-io/app/blob/master/privacy-policy.md'),
                    ),
                    Divider(height: 24.h),
                    SettingsPageListItem(
                      label: 'Github',
                      onTap: () => UI.launchURL('https://github.com/polkawallet-io/app/issues'),
                    ),
                    Divider(height: 24.h),
                    SettingsPageListItem(
                      label: dic['about.feedback'],
                      content: Text("hello@polkawallet.io", style: contentStyle),
                      onTap: () => UI.launchURL('mailto:hello@polkawallet.io'),
                    ),
                  ],
                ),
              ),
              RoundedCard(
                margin: EdgeInsets.fromLTRB(pagePadding, 8.h, pagePadding, 16.h),
                padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
                child: Column(
                  children: [
                    SettingsPageListItem(
                      label: dic['about.version'],
                      content: Row(
                        children: [
                          Visibility(
                            visible: _updateLoading,
                            child: Container(
                              padding: EdgeInsets.only(right: 8.w),
                              child: CupertinoActivityIndicator(radius: 8.r),
                            ),
                          ),
                          Text(_appVersion ?? "", style: contentStyle)
                        ],
                      ),
                      onTap: _checkUpdate,
                    ),
                    Divider(height: 24.h),
                    SettingsPageListItem(
                      label: 'API',
                      content: Container(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Text(currentJSVersion.toString(), style: contentStyle),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
