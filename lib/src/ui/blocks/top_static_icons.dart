import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './../../../assets/presentation/m_store_icons_icons.dart';
import '../../layout/adaptive.dart';
import '../../models/app_state_model.dart';
import '../../ui/accounts/language/language.dart';
import '../../ui/accounts/login/login.dart';
import '../../ui/accounts/wishlist.dart';
import '../../ui/products/products.dart';
import '../../ui/vendor/ui/stores/stores.dart';
class TopStaticIcons extends StatefulWidget {
  TopStaticIcons({Key key}) : super(key: key);
  @override
  _TopStaticIconsState createState() => _TopStaticIconsState();
}

class _TopStaticIconsState extends State<TopStaticIcons> {
  @override
  Widget build(BuildContext context) {
    TextStyle labelstyel = Theme.of(context).textTheme.bodyText1.copyWith(
      fontSize: 10,
    );
    final bool isDesktop = isDisplayDesktop(context);
    final containerWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = containerWidth ~/ (isDesktop ? 300 : 180);
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        height: 100,
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.only(top:0, left: 20, right: 20),
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 5,
          childAspectRatio: 0.7,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                  onTap: () {
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Stores()));*/
                  },
                  child: Column(
                    children: [
                      Card(
                          shape: StadiumBorder(),
                          clipBehavior: Clip.antiAlias,
                          elevation: 2,
                          child:  Container(
                              height: 60,
                              width: 60,
                              color: Colors.red,
                              child: Icon(Icons.notifications, color: Colors.white,))
                      ),
                      SizedBox(height: 4,),
                      Text('Notification', style: labelstyel,)
                    ],
                  )),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Stores()));
                  },
                  child: Column(
                    children: [
                      Card(
                          shape: StadiumBorder(),
                          clipBehavior: Clip.antiAlias,
                          elevation: 2,
                          child:  Container(
                              height: 60,
                              width: 60,
                              color: Colors.purple,
                              child: Icon(MStoreIcons.store_2_fill, color: Colors.white,))
                      ),
                      SizedBox(height: 4,),
                      Text('Stores', style: labelstyel)
                    ],
                  )),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                  onTap: () {
                    var filter = new Map<String, dynamic>();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductsWidget(
                                filter: filter,
                                name: 'New Arrivals')));
                  },
                  child: Column(
                    children: [
                      Card(
                          shape: StadiumBorder(),
                          clipBehavior: Clip.antiAlias,
                          elevation: 2,
                          child:  Container(
                              height: 60,
                              width: 60,
                              color: Colors.amber,
                              child: Icon(Icons.fiber_new, color: Colors.white,))
                      ),
                      SizedBox(height: 4,),
                      Text('New Arrivals', style: labelstyel)
                    ],
                  )),
            ),
            ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                      onTap: () {
                        if (model.user?.id != null && model.user.id > 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WishList()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Login()));
                        }
                      },
                      child: Column(
                        children: [
                          Card(
                              shape: StadiumBorder(),
                              clipBehavior: Clip.antiAlias,
                              elevation: 2,
                              child:  Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.green,
                                  child: Icon(Icons.favorite, color: Colors.white,))
                          ),
                          SizedBox(height: 4,),
                          Text('Wishlist', style: labelstyel)
                        ],
                      )),

                );
              }
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LanguagePage()));
                  },
                  child: Column(
                    children: [
                      Card(
                          shape: StadiumBorder(),
                          clipBehavior: Clip.antiAlias,
                          elevation: 2,
                          child:  Container(
                              height: 60,
                              width: 60,
                              color: Colors.blue,
                              child: Icon(Icons.language, color: Colors.white,))
                      ),
                      SizedBox(height: 4,),
                      Text('Langugae', style: labelstyel)
                    ],
                  )),

            ),
          ],
        ),
      ),
    );/*SliverPadding(
      padding: EdgeInsets.fromLTRB(
          24,
          16,
          24,
          16),
      sliver: SliverGrid(
        //  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                  onTap: () {

                  },
                  child: Card(
                      shape: StadiumBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      child:  Image.asset('lib/assets/images/logo.png'))),
            );
          },
          childCount: 4,
        ),
      ),
    );*/
  }
}
