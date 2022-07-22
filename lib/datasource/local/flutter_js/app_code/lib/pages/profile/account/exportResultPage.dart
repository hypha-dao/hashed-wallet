// @dart=2.9
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/i18n/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class ExportResultPage extends StatelessWidget {
  static final String route = '/account/key';

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'profile');
    final SeedBackupData args = ModalRoute.of(context).settings.arguments;

    final hasDerivePath = args.type != 'keystore' && args.seed.contains('/');
    String seed = args.seed;
    String path = '';
    if (hasDerivePath) {
      final seedSplit = args.seed.split('/');
      seed = seedSplit[0];
      path = '/${seedSplit.sublist(1).join('/')}';
    }

    return Scaffold(
      appBar: AppBar(title: Text(dic['export']), centerTitle: true, leading: BackBtn()),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Column(
              children: <Widget>[
                Visibility(visible: args.type != 'keystore', child: Text(dic['export.warn'])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8.w, 8.h, 0, 8.w),
                        child: Text(
                          I18n.of(context).getDic(i18n_full_dic_ui, 'common')['copy'],
                          style: TextStyle(
                              fontSize: UI.getTextSize(14, context),
                              fontFamily: UI.getFontFamily('TitilliumWeb', context),
                              color: Theme.of(context).toggleableActiveColor),
                        ),
                      ),
                      onTap: () => UI.copyAndNotify(context, seed),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    seed,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Visibility(
                    visible: hasDerivePath,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                              child: Text(I18n.of(context).getDic(i18n_full_dic_app, 'account')['path']),
                            ),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(8.w, 8.h, 0, 8.w),
                                child: Text(
                                  I18n.of(context).getDic(i18n_full_dic_ui, 'common')['copy'],
                                  style: TextStyle(
                                      fontSize: UI.getTextSize(14, context),
                                      fontFamily: UI.getFontFamily('TitilliumWeb', context),
                                      color: Theme.of(context).toggleableActiveColor),
                                ),
                              ),
                              onTap: () => UI.copyAndNotify(context, path),
                            )
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [Text(path, style: Theme.of(context).textTheme.headline4)],
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
