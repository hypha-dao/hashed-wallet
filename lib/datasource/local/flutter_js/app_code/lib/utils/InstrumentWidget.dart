// @dart=2.9
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/InstrumentItemWidget.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/Utils.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/i18n/index.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_ui/components/SkaletonList.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';

export 'package:seeds/datasource/local/flutter_js/app_code/lib/utils/InstrumentItemWidget.dart';

class InstrumentWidget extends StatefulWidget {
  InstrumentWidget(this.datas,
      {Key key,
      @required this.onSwitchChange,
      @required this.onSwitchHideBalance,
      this.hideBalance = false,
      this.enabled = false,
      this.priceCurrency = 'USD',
      this.switchDefi = false,
      this.gradienColors})
      : super(key: key);
  final List<InstrumentData> datas;
  final Function onSwitchChange;
  final Function onSwitchHideBalance;
  final bool hideBalance;
  final bool enabled;
  final String priceCurrency;
  final bool switchDefi;
  final List<Color> gradienColors;
  @override
  _InstrumentWidgetState createState() => _InstrumentWidgetState();
}

class _InstrumentWidgetState extends State<InstrumentWidget> {
  InstrumentItemWidgetController controller = InstrumentItemWidgetController();
  int index = 0;
  bool isTapDown = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.switchAction(isOnClick: false));
    super.initState();
  }

  int getIndex() {
    return index >= widget.datas.length ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - (24.w + 11.w + 34.w) * 2;
    return Column(
      children: [
        Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            margin: EdgeInsets.symmetric(horizontal: 34.w),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                InstrumentItemWidget(
                  controller: controller,
                  onChanged: (index, isOnClick) {
                    if (isOnClick) {
                      widget.onSwitchChange();
                    }
                    if (mounted) {
                      setState(() {
                        this.index = index;
                      });
                    }
                  },
                  datas: widget.datas,
                  initializeIndex: getIndex(),
                  size: Size(width, width / 249 * 168),
                ),
                Container(
                    width: width,
                    height: width / 249 * 168,
                    child: Image.asset(
                      "assets/images/icon_instrument.png",
                      fit: BoxFit.fill,
                    )),
                Container(
                  child: Column(
                    children: [
                      Text(widget.datas[getIndex()].title.length > 0 ? "${widget.datas[getIndex()].title}:" : "",
                          style: TextStyle(
                              fontFamily: UI.getFontFamily('TitilliumWeb', context),
                              fontSize: UI.getTextSize(14, context),
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textSelectionTheme.selectionColor.withAlpha(191))),
                      GestureDetector(
                        onTap: () {
                          widget.onSwitchHideBalance();
                        },
                        child: Text(
                            widget.hideBalance
                                ? "******"
                                : "${Utils.currencySymbol(widget.priceCurrency)}${Fmt.priceFloorFormatter(widget.datas[getIndex()].sumValue, lengthMax: widget.datas[getIndex()].lengthMax)}",
                            style: TextStyle(
                                fontFamily: UI.getFontFamily('SF_Pro', context),
                                fontSize: UI.getTextSize(18, context),
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textSelectionTheme.selectionColor)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15.h),
                        child: GestureDetector(
                            onTapDown: (detail) {
                              setState(() {
                                isTapDown = true;
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                isTapDown = false;
                              });
                            },
                            onTapUp: (detail) {
                              setState(() {
                                isTapDown = false;
                              });
                            },
                            onTap: widget.switchDefi && widget.enabled
                                ? () {
                                    controller.switchAction();
                                  }
                                : null,
                            child: Container(
                              width: 46.w,
                              height: 46.w,
                              decoration: widget.switchDefi
                                  ? BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: widget.gradienColors ??
                                              [Theme.of(context).primaryColor, Theme.of(context).hoverColor]),
                                      borderRadius: BorderRadius.all(Radius.circular(46.w / 2)),
                                    )
                                  : BoxDecoration(
                                      color: Color(0xFF706C6A),
                                      borderRadius: BorderRadius.all(Radius.circular(46.w / 2)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0x61000000),
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                            spreadRadius: 1),
                                      ],
                                    ),
                              // child: Center(
                              child: Center(
                                  child: Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(40.w / 2)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0x4F000000),
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                          spreadRadius: 0),
                                    ],
                                    gradient:
                                        LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [
                                      0.0,
                                      1.0
                                    ], colors: [
                                      Color(isTapDown ? 0xFFBEB9B2 : 0xFFFFFAF1),
                                      Color(isTapDown ? 0xFF74716C : 0xFFB1ADA7),
                                    ])),
                                child: Center(
                                  child: Text(
                                    widget.switchDefi && widget.enabled
                                        ? I18n.of(context).getDic(i18n_full_dic_app, 'assets')['v3.tap']
                                        : '',
                                    style: Theme.of(context).textTheme.headline5?.copyWith(
                                        color: isTapDown ? Colors.white : Color(0xFF757371),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                              // ),
                            )),
                      )
                    ],
                  ),
                )
              ],
            )),
        Container(
          height: 10,
        ),
        getRoundedCardItem(),
      ],
    );
  }

  Widget getRoundedCardItem() {
    if (widget.datas[getIndex()].items.length > 0) {
      return Row(children: [
        ...widget.datas[getIndex()].items.reversed
            .map((e) => Expanded(
                    child: RoundedCard(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.only(right: 3),
                            decoration:
                                BoxDecoration(color: e.color, borderRadius: BorderRadius.all(Radius.circular(10 / 2))),
                          ),
                          Text(
                            e.name,
                            style: TextStyle(
                                fontFamily: UI.getFontFamily('TitilliumWeb', context),
                                fontSize: UI.getTextSize(12, context),
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).textSelectionTheme.selectionColor),
                          )
                        ],
                      ),
                      Text(
                        widget.hideBalance
                            ? "******"
                            : "${Utils.currencySymbol(widget.priceCurrency)}${Fmt.priceFloorFormatter(e.value, lengthMax: widget.datas[getIndex()].lengthMax)}",
                        style: TextStyle(
                            fontFamily: UI.getFontFamily('TitilliumWeb', context),
                            fontSize: UI.getTextSize(12, context),
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).textSelectionTheme.selectionColor),
                      )
                    ],
                  ),
                )))
            .toList()
      ]);
    } else {
      return SkaletionRow(items: 3);
    }
  }
}
