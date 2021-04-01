import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../functions.dart';
import '../../models/category_model.dart';
import '../products/products.dart';

class VendorAllCategories extends StatefulWidget {
  final List<Category> categories;
  const VendorAllCategories({Key key, this.categories}) : super(key: key);
  @override
  _VendorAllCategoriesState createState() => _VendorAllCategoriesState();
}

class _VendorAllCategoriesState extends State<VendorAllCategories> {

  void onCategoryClick(Category category) {
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter, name: category.name)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: buildList(),
    );
  }

  buildList() {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
      child: ListView.builder(
          itemCount: widget.categories.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              children: <Widget>[
                CategoryRow(
                    category: widget.categories[index],
                    onCategoryClick: onCategoryClick),
                Divider(height: 0,)
              ],
            );
          }),
    );
  }
}

class CategoryRow extends StatelessWidget {
  final Category category;
  final void Function(Category category) onCategoryClick;

  CategoryRow({this.category, this.onCategoryClick});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(16.0),
      trailing: Icon(Icons.keyboard_arrow_right),
      isThreeLine: category.description.isEmpty ? false : true,
      onTap: () {
        onCategoryClick(category);
      },
      leading: Container(
        width: 60,
        height: 60,
        child: CachedNetworkImage(
          imageUrl: category.image,
          imageBuilder: (context, imageProvider) => Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            shape: StadiumBorder(),
            child: Ink.image(
              child: InkWell(
                onTap: () {
                  onCategoryClick(category);
                },
              ),
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
          placeholder: (context, url) => Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0.0,
            shape: StadiumBorder(),
            child: Container(color: Colors.black12.withOpacity(0.01)),
          ),
          errorWidget: (context, url, error) => Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0.0,
            shape: StadiumBorder(),
            child: Container(color: Theme.of(context).highlightColor),
          ),
        ),
      ),
      title: Text(
        parseHtmlString(category.name),
        style: Theme.of(context).textTheme.bodyText1,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: category.description.isEmpty ? null : Text(category.description, maxLines: 2, overflow: TextOverflow.ellipsis,),
    );
  }
}
