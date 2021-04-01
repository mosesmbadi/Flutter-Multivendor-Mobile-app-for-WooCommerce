import 'package:flutter/material.dart';
import '../../../blocs/products_bloc.dart';
import '../../../models/app_state_model.dart';
import 'package:intl/intl.dart';
import '../../../models/attributes_model.dart';

class FilterProduct3 extends StatefulWidget {
  final ProductsBloc productsBloc;

  const FilterProduct3({Key key, this.productsBloc}) : super(key: key);
  @override
  _FilterProduct3State createState() => _FilterProduct3State();
}

class _FilterProduct3State extends State<FilterProduct3> {
  var filter = new Map<String, dynamic>();
  final appStateModel = AppStateModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Color(0xFFf2f3f7)
          : Colors.black,
      appBar: AppBar(
        title: Text('Filter'),
        actions: [
          FlatButton(
            child: Text('Done'),
            onPressed: () {
              widget.productsBloc.applyFilter(
                  int.parse(widget.productsBloc.productsFilter['id']),
                  appStateModel.selectedRange.start,
                  appStateModel.selectedRange.end);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: widget.productsBloc.allAttributes,
          builder: (context, AsyncSnapshot<List<AttributesModel>> snapshot) {
            return snapshot.hasData
                ? ListView(children: buildFilterList(snapshot))
                : Container();
          }),
    );
  }

  buildFilterList(AsyncSnapshot<List<AttributesModel>> snapshot) {
    List<Widget> list = new List<Widget>();

    list.add(_priceFilter());
    for (var i = 0; i < snapshot.data.length; i++) {
      if (snapshot.data[i].terms.length != 0) {
        list.add(buildFilter(snapshot, i));
      }
    }

    list.add(_resetFilter());
    return list;
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
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 30),
      child: Card(
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
                  Text('${formatter.format(appStateModel.selectedRange.end)}'),
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
      ),
    );
  }

  Widget buildFilter(AsyncSnapshot<List<AttributesModel>> snapshot, int i) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(1),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: ListTile(
        title: Text(snapshot.data[i].name),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    FilterAttributes(attribute: snapshot.data[i]),
                //fullscreenDialog: true,
              ));
        },
      ),
    );
  }
}

class FilterAttributes extends StatefulWidget {
  final AttributesModel attribute;

  const FilterAttributes({Key key, this.attribute}) : super(key: key);
  @override
  _FilterAttributesState createState() => _FilterAttributesState();
}

class _FilterAttributesState extends State<FilterAttributes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Color(0xFFf2f3f7)
          : Colors.black,
      appBar: AppBar(
        title: Text(widget.attribute.name),
      ),
      body: ListView.builder(
          itemCount: widget.attribute.terms.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
              elevation: 0,
              margin: EdgeInsets.all(0.5),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: CheckboxListTile(
                title: Text(widget.attribute.terms[index].name),
                value: widget.attribute.terms[index].selected,
                onChanged: (bool value) {
                  setState(() {
                    widget.attribute.terms[index].selected = value;
                  });
                },
              ),
            );
          }),
    );
  }
}
