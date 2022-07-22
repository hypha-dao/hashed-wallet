// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';

class JumpToLink extends StatefulWidget {
  JumpToLink(this.url, {this.text, this.color});

  final String text;
  final String url;
  final Color color;

  @override
  _JumpToLinkState createState() => _JumpToLinkState();
}

class _JumpToLinkState extends State<JumpToLink> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              widget.text ?? widget.url,
              style: TextStyle(
                  fontSize: UI.getTextSize(12, context), color: widget.color ?? Theme.of(context).primaryColor),
            ),
          ),
          Icon(Icons.open_in_new, size: 14, color: widget.color ?? Theme.of(context).primaryColor)
        ],
      ),
      onTap: () {
        UI.launchURL(widget.url);
      },
    );
  }
}
