// @dart=2.9
import 'dart:async';

import 'package:seeds/datasource/local/flutter_js/app_code/lib/pages/profile/aboutPage.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/service/index.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/service/walletApi.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/Utils.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/i18n/index.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/utils/app.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/pages/dAppWrapperPage.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AdBanner extends StatefulWidget {
  AdBanner(this.service, this.connectedNode);

  final AppService service;
  final NetworkParams connectedNode;

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  bool _loading = false;
  int _appVersion;

  Future<void> _getAdBannerList() async {
    if (widget.service.store.settings.adBanners.keys.length > 0) return;

    var res = await WalletApi.getAdBannerList();
    widget.service.store.settings.setAdBannerState(res);

    // widget.service.store.settings.claimState =
    //     await WalletApi.getClaim(widget.service.keyring.current.address);
  }

  void _showBannerInvalidAlert() {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          final dic = I18n.of(context).getDic(i18n_full_dic_app, 'public');
          return CupertinoAlertDialog(
            title: Text(dic['banner.invalid']),
            content: Text(dic['banner.invalid.info']),
            actions: [
              CupertinoButton(
                  child: Text(
                    I18n.of(context).getDic(i18n_full_dic_ui, 'common')['cancel'],
                    style: TextStyle(color: Theme.of(context).unselectedWidgetColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                  child: Text(I18n.of(context).getDic(i18n_full_dic_ui, 'common')['ok']),
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(AboutPage.route);
                  })
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAdBannerList();

      Utils.getBuildNumber().then((value) {
        if (mounted) {
          setState(() {
            _appVersion = value;
          });
        }
      });
    });
  }

  List<Widget> buildBannerList() {
    final widgets = <Widget>[];
    final all = [...(widget.service.store.settings.adBanners['all'] as List ?? [])];
    final list = widget.service.store.settings.adBanners[widget.service.plugin.basic.name] as List;
    if (list != null && list.length > 0) {
      all.addAll(list);
    }
    if (all != null && all.length > 0) {
      // todo: remove this filter after ACA claim closed.
      // if (!(widget.service.store.settings.claimState['result'] == true &&
      //     widget.service.store.settings.claimState['claimed'] == false &&
      //     widget.service.store.settings.claimState['originClaimed'] == false)) {
      //   all.removeWhere(
      //       (e) => e['link'] == 'https://distribution.acala.network/claim');
      // }

      // observation account is not support for Dapp page
      if (widget.service.keyring.current.observation == true) {
        all.removeWhere((e) => e['isDapp'] == true);
      }

      widgets.addAll(all.map((e) {
        return GestureDetector(
          child: Image.network(
            e['banner'],
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          onTap: () {
            if (_loading) return;

            setState(() {
              _loading = true;
            });

            final minVersion = e['minVersion'] as int;
            if (minVersion != null && _appVersion < minVersion) {
              _showBannerInvalidAlert();
            } else {
              if (e['isRoute'] == true) {
                final route = e['route'] as String;
                final network = e['routeNetwork'] as String;
                final args = e['routeArgs'] as Map;
                if (network != widget.service.plugin.basic.name) {
                  widget.service.plugin.appUtils.switchNetwork(
                    network,
                    pageRoute: PageRouteParams(route, args: args),
                  );
                } else {
                  Navigator.of(context).pushNamed(route, arguments: args);
                }
              } else if (e['isDapp'] == true) {
                Navigator.of(context).pushNamed(
                  DAppWrapperPage.route,
                  arguments: e['link'],
                );
              } else {
                UI.launchURL(e['link']);
              }
            }

            Timer(Duration(seconds: 1), () {
              if (mounted) {
                setState(() {
                  _loading = false;
                });
              }
            });
          },
        );
      }));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    // return Observer(builder: (_) {
    if (widget.connectedNode == null) {
      return Container();
    }
    var widgets = buildBannerList();
    if (widgets.length == 0) {
      return Container();
    }

    return widgets.length == 1
        ? widgets[0]
        : Container(
            height: (MediaQuery.of(context).size.width - 32.w) / 340.0 * 55,
            width: double.infinity,
            padding: EdgeInsets.zero,
            child: Swiper(
              itemCount: widgets.length,
              itemWidth: double.infinity,
              autoplay: true,
              itemBuilder: (BuildContext context, int index) {
                return widgets[index];
              },
              pagination: SwiperPagination(
                  margin: EdgeInsets.zero,
                  builder: DotSwiperPaginationBuilder(activeColor: Theme.of(context).toggleableActiveColor)),
            ),
          );
    // });
  }
}
