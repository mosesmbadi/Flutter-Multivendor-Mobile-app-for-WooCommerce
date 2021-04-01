import 'package:flutter/material.dart';
import '../../../blocs/products_bloc.dart';
import '../../../models/app_state_model.dart';
import 'package:intl/intl.dart';
import '../../../models/attributes_model.dart';

class FilterProduct2 extends StatefulWidget {
  final ProductsBloc productsBloc;

  const FilterProduct2({Key key, this.productsBloc}) : super(key: key);
  @override
  _FilterProduct2State createState() => _FilterProduct2State();
}

class _FilterProduct2State extends State<FilterProduct2> {
  var filter = new Map<String, dynamic>();
  final appStateModel = AppStateModel();
  String selectedAttribute;

  @override
  void initState() {
    super.initState();
    selectedAttribute = 'price';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appStateModel.blocks.localeText.filter),
        actions: [
          FlatButton(
            child: Text(appStateModel.blocks.localeText.reset),
            onPressed: () {
              widget.productsBloc.clearFilter();
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: widget.productsBloc.allAttributes,
          builder: (context, AsyncSnapshot<List<AttributesModel>> snapshot) {
            return snapshot.hasData ? _buildFilter(snapshot) : Container();
          }),
    );
  }

  _buildFilter(AsyncSnapshot<List<AttributesModel>> snapshot) {
    Color backGroundColor = Theme.of(context).brightness == Brightness.light
        ? Color(0xFFf3f4ef)
        : Colors.black;
    return Stack(
      children: [
        Row(
          children: [
            Container(
              color: backGroundColor,
              width: MediaQuery.of(context).size.width * 0.35,
              child: ListView.builder(
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (BuildContext ctxt, int index) {
                    if (index == 0) {
                      return Container(
                        decoration: BoxDecoration(
                          color: selectedAttribute == 'price'
                              ? Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black
                              : backGroundColor,
                          border: Border(
                            left: BorderSide(
                              //                   <--- left side
                              color: selectedAttribute == 'price'
                                  ? Theme.of(context).accentColor
                                  : backGroundColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: ListTile(
                          selected: selectedAttribute == 'price',
                          title: Text(appStateModel.blocks.localeText.price, maxLines: 2),
                          onTap: () {
                            setState(() {
                              selectedAttribute = 'price';
                            });
                          },
                        ),
                      );
                    } else
                      return Container(
                        decoration: BoxDecoration(
                          color: selectedAttribute ==
                                  snapshot.data[index - 1].id
                              ? Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black
                              : backGroundColor,
                          border: Border(
                            left: BorderSide(
                              //                   <--- left side
                              color: selectedAttribute ==
                                      snapshot.data[index - 1].id
                                  ? Theme.of(context).accentColor
                                  : backGroundColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: ListTile(
                          selected:
                              selectedAttribute == snapshot.data[index - 1].id,
                          title:
                              Text(snapshot.data[index - 1].name, maxLines: 2),
                          onTap: () {
                            setState(() {
                              selectedAttribute = snapshot.data[index - 1].id;
                            });
                          },
                        ),
                      );
                  }),
            ),
            Expanded(
                child: selectedAttribute == 'price'
                    ? _priceFilter()
                    : _buildTerms(snapshot.data.singleWhere(
                        (element) => selectedAttribute == element.id)))
          ],
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width * 0.65,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: RaisedButton(
                      elevation: 0,
                      onPressed: () {
                        widget.productsBloc.applyFilter(
                            int.parse(widget.productsBloc.productsFilter['id']),
                            appStateModel.selectedRange.start,
                            appStateModel.selectedRange.end);
                        Navigator.pop(context);
                      },
                      child: Text('Apply'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _resetFilter() {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 30),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.all(1),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: ListTile(
            title: Text('Reset All', textAlign: TextAlign.center),
            onTap: () {
              widget.productsBloc.clearFilter();
            }),
      ),
    );
  }

  _priceFilter() {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: appStateModel.blocks.settings.priceDecimal,
        name: appStateModel.selectedCurrency);
    return ListView(
      children: [
        Card(
          elevation: 0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        '${formatter.format(appStateModel.selectedRange.start)}'),
                    Text(
                        '${formatter.format(appStateModel.selectedRange.end)}'),
                  ],
                ),
              ),
              Container(
                child: RangeSlider(
                    min: 0,
                    max: appStateModel.blocks.maxPrice.toDouble(),
                    divisions: appStateModel.maxPrice.toInt(),
                    values: appStateModel.selectedRange,
                    labels: RangeLabels(
                        '${formatter.format(appStateModel.selectedRange.start)}',
                        '${formatter.format(appStateModel.selectedRange.end)}'),
                    onChanged: (RangeValues newRange) {
                      appStateModel.updateRangeValue(newRange);
                      setState(() {
                        appStateModel.selectedRange = newRange;
                      });
                    }),
              ),
            ],
          ),
        )
      ],
    );
  }

  _buildTerms(AttributesModel attribute) {
    return ListView.builder(
        itemCount: attribute.terms.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Card(
            elevation: 0,
            margin: EdgeInsets.all(0.5),
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: CheckboxListTile(
              title: Text(attribute.terms[index].name),
              value: attribute.terms[index].selected,
              onChanged: (bool value) {
                setState(() {
                  attribute.terms[index].selected = value;
                });
              },
            ),
          );
        });
  }
}
