// @dart=2.9
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/i18n/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/back.dart';

class AnnouncePageParams {
  AnnouncePageParams({this.title, this.link});
  final String title;
  final String link;
}

class AnnouncementPage extends StatelessWidget {
  static final String route = '/announce';

  @override
  Widget build(BuildContext context) {
    final Map dic = I18n.of(context).getDic(i18n_full_dic_app, 'assets');
    final AnnouncePageParams params = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text(dic['announce']), centerTitle: true, leading: BackBtn()),
      body: SafeArea(
        child: WebView(
          initialUrl: params.link,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }
}
