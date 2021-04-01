import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../src/models/app_state_model.dart';
import '../../models/category_model.dart';
import '../products/products.dart';

class Categories2 extends StatefulWidget {
  @override
  _Categories2State createState() => _Categories2State();
}

class _Categories2State extends State<Categories2> {

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
            builder: (context) => ProductsWidget(
                filter: filter, name: category.name)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appStateModel.blocks.localeText.categories),),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (model.blocks?.categories != null) {

            mainCategories = model.blocks.categories.where((cat) => cat.parent == 0).toList();
            selectedCategory = mainCategories[selectedCategoryIndex];
            subCategories = model.blocks.categories.where((cat) => cat.parent == selectedCategory.id).toList();

            return buildList();
          } return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  buildList() {
    return ListView.builder(
        itemCount: mainCategories.length,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int index) {
          return new CategoryRow(category: mainCategories[index], onCategoryClick: onCategoryClick);
        });
  }
}

class CategoryRow extends StatelessWidget {
  final Category category;
  final void Function(Category category) onCategoryClick;

  CategoryRow({this.category, this.onCategoryClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: StadiumBorder(),
      elevation: 0.5,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            customBorder: StadiumBorder(),
            onTap: () {
              onCategoryClick(category);
            },
            child: Container(
              height: 122,
              margin: EdgeInsets.only(left: 1, right: 35),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 122,
                      height: 122,
                      child: CachedNetworkImage(
                        imageUrl: category.image,
                        imageBuilder: (context, imageProvider) => Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 0.0,
                          margin: EdgeInsets.all(10.0),
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
                        ),
                        errorWidget: (context, url, error) => Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 0.0,
                            margin: EdgeInsets.all(10.0),
                            shape: StadiumBorder(),
                            child: Container(color: Colors.black12,)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        //height: 70,
                        margin: EdgeInsets.only(left: 13, top: 0, right: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: -0.24,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            category.description.isNotEmpty ? Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Text(
                                  category.description,
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 0.07,
                                    color:Theme.of(context).hintColor,
                                  ),
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ) : Container(),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 4),
                                child: Text(
                                  category.count.toString() + ' Items',
                                  style: TextStyle(
                                    color:Theme.of(context).hintColor,
                                    fontSize: 15,
                                    letterSpacing: -0.24,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

