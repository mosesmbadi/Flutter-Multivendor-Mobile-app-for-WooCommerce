import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../functions.dart';

import '../../../src/models/app_state_model.dart';
import '../../models/category_model.dart';
import '../products/products.dart';

class Categories8 extends StatefulWidget {
  @override
  _Categories8State createState() => _Categories8State();
}

class _Categories8State extends State<Categories8> {
  List<Category> mainCategories;
  List<Category> subCategories;
  Category selectedCategory;
  int mainCategoryId = 0;
  int selectedCategoryIndex = 0;
  AppStateModel appStateModel = AppStateModel();

  void onCategoryClick(Category category) {
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductsWidget(filter: filter, name: category.name)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appStateModel.blocks.localeText.categories),
      ),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (model.blocks?.categories != null) {
            mainCategories = model.blocks.categories
                .where((cat) => cat.parent == 0)
                .toList();
            selectedCategory = mainCategories[selectedCategoryIndex];
            subCategories = model.blocks.categories
                .where((cat) => cat.parent == selectedCategory.id)
                .toList();

            return buildList();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  buildList() {
    return Container(
        padding: EdgeInsets.all(0.0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 120,
                childAspectRatio: 9 / 9),
            itemCount: mainCategories.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Column(
                children: <Widget>[
                  CategoryRow(
                      category: mainCategories[index],
                      onCategoryClick: onCategoryClick),
                  Divider(
                    height: 0,
                  )
                ],
              );
            }));
  }
}

class CategoryRow extends StatelessWidget {
  final Category category;
  final void Function(Category category) onCategoryClick;

  CategoryRow({this.category, this.onCategoryClick});

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width ~/ 120;
    double height =
        (MediaQuery.of(context).size.width - (crossAxisCount * 16)) /
            crossAxisCount;

    Widget featuredImage = category.image != null
        ? CachedNetworkImage(
            imageUrl: category.image,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Container(color: Colors.black12),
            errorWidget: (context, url, error) =>
                Container(color: Colors.white),
          )
        : Container();
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: () => _detail(category, context),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                Container(
                  height: height - 40,
                  child: featuredImage,
                ),
                Container(
                  height: 35,
                  child: Center(
                    child: new Text(parseHtmlString(category.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _detail(Category, BuildContext context) {
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductsWidget(filter: filter, name: category.name)));
  }
}
