import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './../../../models/app_state_model.dart';
import '../../../blocs/products_bloc.dart';
import '../../../models/attributes_model.dart';
import '../../../models/category_model.dart';
enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class FilterProduct extends StatefulWidget {
  final ProductsBloc productsBloc;
  final List<Category> categories;
  final Function onSelectSubcategory;

  FilterProduct(
      {Key key,
      this.productsBloc,
      this.categories,
      this.onSelectSubcategory})
      : super(key: key);

  @override
  _FilterProductState createState() => _FilterProductState();
}

class _FilterProductState extends State<FilterProduct> {
  ScrollController _scrollController = new ScrollController();

  var filter = new Map<String, dynamic>();
  final appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appStateModel.blocks.localeText.filter),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.clear_all),
              onPressed: () {
                setState(() {
                  widget.productsBloc.clearFilter();
                });
              })
        ],
      ),
      body: StreamBuilder(
        stream: widget.productsBloc.allAttributes,
        builder: (context, AsyncSnapshot<List<AttributesModel>> snapshot) {
          if (snapshot.hasData) {
            return Stack(children: <Widget>[
              CustomScrollView(
                controller: _scrollController,
                slivers: buildFilterList(snapshot),
              ),
              Positioned(
                bottom: 16.0,
                left: 10.0,
                right: 10.0,
                child: SizedBox(
                  width: 80.0,
                  child: RaisedButton(
                    child: Text(appStateModel.blocks.localeText.apply),
                    onPressed: () {
                      widget.productsBloc.applyFilter(int.parse(widget.productsBloc.productsFilter['id']), appStateModel.selectedRange.start, appStateModel.selectedRange.end);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ]);
          } else if (snapshot.hasData && snapshot.data.length == 0) {
            return Container();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  buildFilterList(AsyncSnapshot<List<AttributesModel>> snapshot) {
    List<Widget> list = new List<Widget>();

    /*if (widget.subcategories.length != 0) {
      list.add(buildHeader('Categories'));
      list.add(buildSubcategories());
    }*/

    list.add(buildHeader('Price'));
    list.add(priceSlider());

    for (var i = 0; i < snapshot.data.length; i++) {
      if (snapshot.data[i].terms.length != 0) {
        list.add(buildHeader(snapshot.data[i].name));
        list.add(buildFilter(snapshot, i));
      }
    }
    list.add(SliverPadding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
    ));
    return list;
  }

  Widget priceSlider() {
    final NumberFormat formatter = NumberFormat.currency(
        decimalDigits: appStateModel.blocks.settings.priceDecimal, name: appStateModel.selectedCurrency);
    return SliverPadding(
      padding: EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10),
              child: RangeSlider(
                min: 0,
                max: appStateModel.blocks.maxPrice.toDouble(),
                divisions: appStateModel.maxPrice.toInt(),
                values: appStateModel.selectedRange,
                labels: RangeLabels('${formatter.format(appStateModel.selectedRange.start)}', '${formatter.format(appStateModel.selectedRange.end)}'),
                onChanged: (RangeValues newRange) {
                  appStateModel.updateRangeValue(newRange);
                  setState(() {
                    appStateModel.selectedRange = newRange;
                  });
                }),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0.0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${formatter.format(appStateModel.selectedRange.start)}'),
                  Text('${formatter.format(appStateModel.selectedRange.end)}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFilter(
      AsyncSnapshot<List<AttributesModel>> snapshot, int filterIndex) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
              value: snapshot.data[filterIndex].terms[index].selected,
              onChanged: (bool value) {
                setState(() {
                  snapshot.data[filterIndex].terms[index].selected = value;
                });
              },
            ),
            Text(snapshot.data[filterIndex].terms[index].name),
          ],
        );
      }, childCount: snapshot.data[filterIndex].terms.length),
    );
  }

  Widget buildSubcategories() {
    return SliverPadding(
      padding: EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 110.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 3.5,
        ),
        delegate:
            new SliverChildBuilderDelegate((BuildContext context, int index) {
          return Container(
            child: RaisedButton(
              onPressed: () {
                widget.onSelectSubcategory(widget.categories[index].id);
                Navigator.pop(context);
              },
              child: Text(
                widget.categories[index].name,
                style: TextStyle(fontSize: 11.0),
                maxLines: 2,
              ),
            ),
          );
        }, childCount: widget.categories.length),
      ),
    );
  }

  Widget buildHeader(String name) {
    return SliverToBoxAdapter(
      child: Container(
        height: 42.0,
        padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
    );
  }
}
