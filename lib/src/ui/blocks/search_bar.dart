import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/app_state_model.dart';
import '../../ui/checkout/cart/cart4.dart';
import '../../ui/home/search.dart';

class SearchBar extends StatefulWidget {
  final bool isVisible;
  SearchBar({Key key, this.isVisible}) : super(key: key);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        //height: 110,
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: widget.isVisible ? Colors.amber : Colors.transparent,
          title: buildAppbarSearch(context),
        ));
  }
}

Row buildAppbarSearch(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        child: InkWell(
          //onTap: () => _scanBarCode(),
          child: Icon(
            FlutterIcons.camera_fea,
            color: Theme.of(context)
                .primaryIconTheme
                .color, //Theme.of(context).primaryIconTheme.color,Theme.of(context).hintColor,
          ),
        ),
      ),
      Expanded(
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            enableFeedback: false,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Search();
              }));
            },
            child: TextField(
              //showCursor: false,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Search products',
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(.7),
                  fontSize: 16,
                  fontFamily: 'Circular',
                ),
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).inputDecorationTheme.fillColor
                    : Colors.white,
                filled: true,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Theme.of(context).focusColor,
                    width: 0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Theme.of(context).focusColor,
                    width: 0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Theme.of(context).focusColor,
                    width: 0,
                  ),
                ),
                contentPadding: EdgeInsets.all(6),
                prefixIcon: Icon(
                  FontAwesomeIcons.search,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CartPage(),
                fullscreenDialog: true,
              ));
        },
        child: Stack(children: <Widget>[
          Icon(
            FlutterIcons.shopping_cart_fea,
            color: Theme.of(context)
                .primaryIconTheme
                .color, //Theme.of(context).hintColor
          ),
          new Positioned(
            top: -3.0,
            right: -3.0,
            child: ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
              if (model.count != 0) {
                return Card(
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    shape: StadiumBorder(),
                    color: Colors.red,
                    child: Container(
                        padding: EdgeInsets.all(2),
                        constraints: BoxConstraints(minWidth: 20.0),
                        child: Center(
                            child: Text(
                          model.count.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                        ))));
              } else
                return Container();
            }),
          ),
        ]),
      ),
    ],
  );
}
