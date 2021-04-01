import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../functions.dart';
import '../../../models/app_state_model.dart';
import '../../../models/category_model.dart';
import '../../products/products.dart';

class MyDrawer extends StatefulWidget {

  final appStateModel = AppStateModel();

  MyDrawer({Key key})
      : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.only(top: 16.0),
        color: Colors.black87,
        child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              if (model.blocks?.categories != null) {
                List<Category> mainCategories = model.blocks.categories.where((cat) => cat.parent == 0).toList();
                return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding:EdgeInsets.only(top: 12),
                        child: ListTile(
                          title: Container(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'MY',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Lexend_Deca',
                                      letterSpacing: 0.5,
                                      color: Colors.cyan,
                                      fontSize: 20,
                                    ),),
                                  Text(
                                    ' STORE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Lexend_Deca',
                                        letterSpacing: 0.5,
                                        color: Colors.yellow,
                                        fontSize: 20
                                    ),),
                                ],
                              )
                          ),
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.all(Radius.circular(2.0))
                              ),
                              width: 30,
                              height: 30,
                              child: Icon(FontAwesomeIcons.shoppingBasket, size: 20, color: Colors.orangeAccent[100]),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                                '5% Discount on all orders',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Lexend_Deca',
                                    letterSpacing: 0.5,
                                    color: Colors.grey,
                                    fontSize: 12
                                )
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.4,
                        height: 3,
                      ),
                    ]
                  )
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ListTile(
                        leading: _buildLeadingIcon(icon: FontAwesomeIcons.comment, bgColor: Colors.white, iconColor: Colors.red),
                        title: Text(widget.appStateModel.blocks.localeText.chat,
                            style: menuItemStyle()),
                        onTap: () => _openWhatsApp(
                            widget.appStateModel.blocks.settings.whatsappNumber),
                      ),
                      ListTile(
                        leading: _buildLeadingIcon(icon: Icons.call, bgColor: Colors.red, iconColor: Colors.white),
                        title: Text(widget.appStateModel.blocks.localeText.call,
                            style: menuItemStyle()),
                        onTap: () => _callNumber(
                            widget.appStateModel.blocks.settings.whatsappNumber),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.4,
                        height: 3,
                      ),
                      ListTile(
                        leading: _buildLeadingIcon(icon: Icons.home, bgColor: Colors.red, iconColor: Colors.white),
                        title: Text(widget.appStateModel.blocks.localeText.home,
                            style: menuItemStyle()),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: _buildLeadingIcon(icon: FontAwesomeIcons.tag, bgColor: Colors.orangeAccent, iconColor: Colors.white),
                        title: Text(widget.appStateModel.blocks.localeText.sales,
                            style: menuItemStyle()),
                        onTap: () {
                          var filter = new Map<String, dynamic>();
                          filter['on_sale'] = '1';
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsWidget(
                                      filter: filter,
                                      name: widget.appStateModel.blocks.localeText.sales)));
                        },
                      ),
                      ListTile(
                        leading: _buildLeadingIcon(icon: Icons.lens, bgColor: Colors.lightGreen, iconColor: Colors.white),
                        title: Text(widget.appStateModel.blocks.localeText.localeTextNew,
                            style: menuItemStyle()),
                        onTap: () {
                          var filter = new Map<String, dynamic>();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsWidget(
                                      filter: filter,
                                      name: widget.appStateModel.blocks.localeText.localeTextNew)));
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.4,
                        height: 3,
                      ),
                    ]
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return _buildTile(mainCategories[index]);
                    },
                    childCount: mainCategories.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 0.4,
                    height: 3,
                  ),
                )
              ],
            );
            } else {
              return Center(child: CircularProgressIndicator(),);
            }
          }
        ),
      ),
    );
  }
  Color leadingIconColor() => Theme.of(context).brightness == Brightness.light ? Colors.blueGrey : Colors.grey;
  Color trailingIconColor() => Theme.of(context).brightness == Brightness.light ? Colors.grey : Colors.grey;

  Widget _buildTile(Category category) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              _onTap(category);
            },
            leading: leadingIcon(category),
            trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white,),
            title: Text(
                parseHtmlString(category.name),
                style: menuItemStyle()
            ),
          ),
          _divider(context),
        ],
      ),
    );
  }

  TextStyle menuItemStyle() {
    return TextStyle(
        fontWeight: FontWeight.w300,
        letterSpacing: 0.5,
        color: Colors.white,
        fontSize: 18
    );
  }

  Container leadingIcon(Category category) {
    return Container(
      width: 30,
      height: 30,
      child: CachedNetworkImage(
        imageUrl: category.image != null ? category.image : '',
        imageBuilder: (context, imageProvider) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          margin: EdgeInsets.all(0.0),
          //shape: StadiumBorder(),
          child: Ink.image(
            child: InkWell(
              onTap: () {
                //onCategoryClick(category);
              },
            ),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (context, url) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          //shape: StadiumBorder(),
        ),
        errorWidget: (context, url, error) => Card(
          elevation: 0.0,
          color: Colors.white,
          //shape: StadiumBorder(),
        ),
      ),
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

  void _onTapTag({String tag, String name}) {
    var filter = new Map<String, dynamic>();
    filter['tag'] = tag;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter,
                name: name)));
  }

  _divider(BuildContext context) {
    return Divider(
      color: Theme.of(context).brightness == Brightness.light ? Colors.black45 : Colors.white,
      thickness: 0.2,
      height: 2,
      indent: 60,
    );
  }

  _buildLeadingIcon({IconData icon, Color bgColor, Color iconColor}) {
    return Container(
        width: 30,
        height: 30,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.all(Radius.circular(2.0))
        ),
        child: Icon(icon, color: iconColor, size: 20, )
    );
  }

  Future _openWhatsApp(String number) async {
    final url = 'https://wa.me/' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _callNumber(String number) async {
    final url = 'tel:' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}