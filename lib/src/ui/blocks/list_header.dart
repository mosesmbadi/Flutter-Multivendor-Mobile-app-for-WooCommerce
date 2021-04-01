import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/blocks_model.dart';
import 'count_down.dart';
import 'hex_color.dart';
class ListHeader extends StatefulWidget {
  final Block block;
  ListHeader({Key key, this.block}) : super(key: key);

  @override
  _ListHeaderState createState() => _ListHeaderState();
}

class _ListHeaderState extends State<ListHeader> {
  @override
  Widget build(BuildContext context) {
    Color bgColor = HexColor(widget.block.bgColor);
    double textAlign = headerAlign(widget.block.headerAlign);
    TextStyle subhead = Theme.of(context).brightness != Brightness.dark
        ? Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: HexColor(widget.block.titleColor))
        : Theme.of(context).textTheme.headline6;

    if(widget.block.blockType == 'flash_sale_block' && textAlign != null) {
      var dateTo = DateFormat('M/d/yyyy mm:ss').parse(widget.block.saleEnds);
      var dateFrom = DateTime.now();
      final difference = dateTo.difference(dateFrom).inSeconds;

      TextStyle _textStyleCounter = Theme.of(context)
          .textTheme
          .bodyText2
          .copyWith(color: bgColor, fontSize: 12);

      return !difference.isNegative ? Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.fromLTRB(
              widget.block.paddingBetween + 4,
              double.parse(widget.block.paddingTop.toString()),
              widget.block.paddingBetween + 4,
              0.0),
          color: Theme.of(context).brightness != Brightness.dark
              ? bgColor
              : Theme.of(context).scaffoldBackgroundColor,
          alignment: Alignment(textAlign, 0),
          height: 60,
          child: Countdown(
            duration: Duration(seconds: difference),
            builder: (BuildContext ctx, Duration remaining) {
              return Row(
                mainAxisAlignment: widget.block.headerAlign == 'top_center' ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Text(
                        widget.block.title,
                        textAlign: TextAlign.start,
                        style: subhead,
                      )),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: new BoxDecoration(
                              color: HexColor(widget.block.titleColor),
                              borderRadius:
                              new BorderRadius.all(Radius.circular(2.0))),
                          margin: EdgeInsets.all(4),
                          child: Center(
                              child: Text('${remaining.inHours.clamp(0, 99)}',
                                  maxLines: 1,
                                  style: _textStyleCounter)),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          margin: EdgeInsets.all(4),
                          decoration: new BoxDecoration(
                              color: HexColor(widget.block.titleColor),
                              borderRadius:
                              new BorderRadius.all(Radius.circular(2.0))),
                          child: Center(
                              child: Text(
                                  '${remaining.inMinutes.remainder(60)}',
                                  style: _textStyleCounter)),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: new BoxDecoration(
                              color: HexColor(widget.block.titleColor),
                              borderRadius:
                              new BorderRadius.all(Radius.circular(2.0))),
                          margin: EdgeInsets.all(4),
                          child: Center(
                              child: Text(
                                  '${remaining.inSeconds.remainder(60)}',
                                  style: _textStyleCounter)),
                        ),
                      ]),
                ],
              );
            },
          ),
        ),
      ) : Container();
    }

    if (textAlign != null) {
      return Container(
          padding: EdgeInsets.fromLTRB(
              widget.block.paddingBetween + 4,
              double.parse(widget.block.paddingTop.toString()),
              widget.block.paddingBetween + 4,
              16.0),
          color: Theme.of(context).brightness != Brightness.dark
              ? bgColor
              : Theme.of(context).scaffoldBackgroundColor,
          alignment: Alignment(textAlign, 0),
          child: Text(
            widget.block.title,
            textAlign: TextAlign.start,
            style: subhead,
          ));
    } else {
      return Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.fromLTRB(
            widget.block.paddingBetween,
            double.parse(widget.block.paddingTop.toString()),
            widget.block.paddingBetween,
            0.0),
        color: Theme.of(context).brightness != Brightness.dark
            ? bgColor
            : Theme.of(context).canvasColor,
      );
    }
  }

  double headerAlign(String align) {
    switch (align) {
      case 'top_left':
        return -1;
      case 'top_right':
        return 1;
      case 'top_center':
        return 0;
      case 'floating':
        return 2;
      case 'none':
        return null;
      default:
        return -1;
    }
  }
}
