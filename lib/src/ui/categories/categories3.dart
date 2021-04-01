import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../src/models/app_state_model.dart';
import '../../models/category_model.dart';
import '../products/products.dart';

class Categories3 extends StatefulWidget {
  @override
  _Categories3State createState() => _Categories3State();
}

class _Categories3State extends State<Categories3> {

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
    return Container(
      padding: EdgeInsets.all(0.0),
      child: ListView.builder(
          itemCount: mainCategories.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              children: <Widget>[
                CategoryRow(
                    category: mainCategories[index],
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
      contentPadding: EdgeInsets.all(10.0),
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
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.black12,
          ),
        ),
      ),
      title: Text(
        category.name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        //textAlign: TextAlign.right,
      ),
      subtitle: category.description.isEmpty ? null : Text(category.description, maxLines: 2, overflow: TextOverflow.ellipsis,),
    );
  }
}
