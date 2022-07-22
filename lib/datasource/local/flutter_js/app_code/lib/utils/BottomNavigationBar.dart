// @dart=2.9
import 'dart:math';

import 'package:seeds/datasource/local/flutter_js/app_code/lib/service/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polkawallet_sdk/plugin/homeNavItem.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:polkawallet_ui/components/circularProgressBar.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';

import 'i18n/index.dart';

class BottomBarScaffold extends StatefulWidget {
  BottomBarScaffold(
      {@required this.body,
      @required this.pages,
      @required this.tabIndex,
      @required this.onChanged,
      @required this.service,
      Key key})
      : super(key: key);
  final Widget body;
  final List<HomeNavItem> pages;
  final Function(int) onChanged;
  final int tabIndex;
  final AppService service;

  @override
  _BottomBarScaffoldState createState() => _BottomBarScaffoldState();
}

class _BottomBarScaffoldState extends State<BottomBarScaffold> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    final centralIndex = widget.pages.length ~/ 2;
    for (int i = 0; i < widget.pages.length; i++) {
      if (i == centralIndex) {
        children.insert(
            i,
            Container(
              width: (MediaQuery.of(context).size.width - 32) / 3,
            ));
      } else if (I18n.of(context).getDic(i18n_full_dic_app, 'profile')['title'] == widget.pages[i].text) {
        children.add(Observer(builder: (_) {
          final communityUnreadNumber =
              (widget.service.store.settings.communityUnreadNumber[widget.service.plugin.basic.name] ?? 0) +
                  (widget.service.store.settings.communityUnreadNumber['all'] ?? 0);
          final systemUnreadNumber = widget.service.store.settings.systemUnreadNumber;
          return NavItem(
            widget.pages[i],
            i == widget.tabIndex,
            (item) {
              setState(() {
                final index = widget.pages.indexWhere((element) => element.text == item.text);
                widget.onChanged(index);
              });
            },
            isRedDot: communityUnreadNumber + systemUnreadNumber > 0,
          );
        }));
      } else {
        children.add(NavItem(widget.pages[i], i == widget.tabIndex, (item) {
          setState(() {
            final index = widget.pages.indexWhere((element) => element.text == item.text);
            widget.onChanged(index);
          });
        }));
      }
    }
    return Scaffold(
      body: widget.body,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: SimpleShadow(
        child: BottomAppBar(
          color: Color(0xFFE0DEDA),
          shape: CustomNotchedShape(context),
          child: SizedBox(height: 64, child: Row(children: children)),
        ),
        opacity: 0.4, // Default: 0.5
        color: Color(0xAA000000), // Default: Black
        offset: Offset(0, -1), // Default: Offset(2, 2)
        sigma: 2, // Default: 2
      ),
      floatingActionButton: CentralNavItem(widget.pages[centralIndex], centralIndex == widget.tabIndex, (item) {
        widget.onChanged(centralIndex);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class NavItem extends StatelessWidget {
  final HomeNavItem item;
  final bool active;
  final bool isRedDot;
  final void Function(HomeNavItem) onPressed;

  const NavItem(this.item, this.active, this.onPressed, {this.isRedDot = false});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.caption;
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.only(top: 4, bottom: 4),
        onPressed: () => onPressed(item),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Icon(item.icon, color: active ? Color(0xfffed802) : style?.color),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 32,
                child: active ? item.iconActive : item.icon,
              ),
              Visibility(
                  visible: this.isRedDot,
                  child: Container(
                    width: 9,
                    height: 9,
                    margin: EdgeInsets.only(right: 1, top: 1),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4.5), color: Theme.of(context).errorColor),
                  ))
            ],
          ),
          Text(
            item.text,
            style: style?.copyWith(
                color: active ? Theme.of(context).textSelectionTheme.selectionColor : Color(0xFF9D9A98)),
          )
        ]),
      ),
    );
  }
}

class CentralNavItem extends StatelessWidget {
  CentralNavItem(this.item, this.active, this.onPressed);

  final HomeNavItem item;
  final bool active;
  final void Function(HomeNavItem) onPressed;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.caption;
    return Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
          CentraNavBtn(
            onPressed: () => onPressed(item),
            active: active,
            child: Center(
              child: Container(
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(56 / 2)),
                    border: Border.all(color: Color(!active ? 0xFFF4F2F0 : 0xFFBFBEBD), width: 0.5),
                    gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, stops: [
                      0.0,
                      1.0
                    ], colors: [
                      Color(!active ? 0xFFEEECE8 : 0xFF807D78),
                      Color(!active ? 0xFFB0ACA6 : 0xFFB0ACA6),
                    ])),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    child: active ? item.iconActive : item.icon,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            item.text,
            style: style?.copyWith(
                color: active ? Theme.of(context).textSelectionTheme.selectionColor : Color(0xFF9D9A98)),
          ),
        ]));
  }
}

class CentraNavBtn extends StatefulWidget {
  CentraNavBtn({this.active, this.child, this.onPressed, Key key}) : super(key: key);
  final bool active;
  Widget child;
  void Function() onPressed;

  @override
  _CentraNavBtnState createState() => _CentraNavBtnState();
}

class _CentraNavBtnState extends State<CentraNavBtn> with TickerProviderStateMixin {
  AnimationController controller;
  double animationNumber = 1;
  Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final buttonSize = 69.0;
    return GestureDetector(
        onTapUp: (tapUpDetails) {
          if (!widget.active) {
            this.controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
            animation = Tween(begin: 0.0, end: 1.0).animate(controller);
            animation.addListener(() {
              setState(() {
                animationNumber = animation.value;
              });
            });
            controller.forward();
          }
        },
        onTap: () => widget.onPressed(),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          child: FittedBox(
            child: FloatingActionButton(
                onPressed: null,
                child: Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    color: Color(0xFF706C6A),
                    borderRadius: BorderRadius.all(Radius.circular(buttonSize / 2)),
                    boxShadow: [
                      BoxShadow(color: Color(0x61000000), offset: Offset(1, 1), blurRadius: 2, spreadRadius: 1),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: buttonSize,
                        height: buttonSize,
                        child: CustomPaint(
                          painter: CircularProgressBar(
                              width: 3,
                              lineColor: [Color(0xFFFF6732), Color(0xFFFF9F7E), Color(0xFFFF6732)],
                              progress: widget.active ? animationNumber : 0),
                        ),
                      ),
                      widget.child
                    ],
                  ),
                )),
          ),
        ));
  }
}

class CustomNotchedShape extends NotchedShape {
  final BuildContext context;
  const CustomNotchedShape(this.context);

  @override
  Path getOuterPath(Rect host, Rect guest) {
    const radius = 70.0;
    const lx = 40.0;
    const ly = 22;
    const bx = 25.0;
    const by = 40.0;
    var x = (MediaQuery.of(context).size.width - radius) / 2 - lx;
    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(x, host.top)
      // ..lineTo(x += lx, host.top - ly)
      ..quadraticBezierTo(x + bx, host.top, x += lx, host.top - ly)
      // ..lineTo(x += radius, host.top - ly)
      ..quadraticBezierTo(x + radius / 5, host.top - by, x += radius / 2, host.top - by)
      ..quadraticBezierTo(x + radius / 3.5, host.top - by, x += radius / 2, host.top - ly)
      // ..lineTo(x += lx, host.top)
      ..quadraticBezierTo((x += lx) - bx, host.top, x, host.top)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom);
  }
}
