import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../models/app_state_model.dart';
import '../../../models/category_model.dart';
import '../../products/products.dart';
import 'category_list.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  final TextStyle _biggerFont =
  const TextStyle(fontSize: 24);

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  @override
  Future initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Container(),
            accountName: Text(
              'FLUTTER',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage(
                'lib/images/menu_header.jpg',
              ),
            ),
            margin: EdgeInsets.zero,
          ),
          MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: Container(
              child: Expanded(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        leading: Icon(CupertinoIcons.home),
                        title: Text(ScopedModel.of<AppStateModel>(context).blocks.localeText.home),
                      ),
                      Expanded(child: buildList()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        if (model.blocks?.categories != null) {
          return CategoryList(
              categories: model.blocks.categories, onTapCategory: _onTap);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _onTap(Category category) {
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
      Navigator.push(
        context,
          MaterialPageRoute(
              builder: (context) => ProductsWidget(
                  filter: filter,
                  name: category.name)));
  }
}
