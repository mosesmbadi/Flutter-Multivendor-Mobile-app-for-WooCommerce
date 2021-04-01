import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../blocs/search_bloc.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/product_model.dart';
import '../../../../products/product_grid/product_item4.dart';

class Search extends StatefulWidget {
  final String vendorId;
  final SearchBloc searchBloc = SearchBloc();
  Search({Key key, this.vendorId}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  ScrollController _scrollController = new ScrollController();
  TextEditingController inputController = new TextEditingController();
  final appStateModel = AppStateModel();

  Timer _debounce;

  @override
  void initState() {
    super.initState();
    widget.searchBloc.filter['vendor'] = widget.vendorId;
  }

  @override
  void dispose() {
    _debounce.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(inputController.text.isNotEmpty) {
        widget.searchBloc.fetchSearchResults(inputController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: TextFormField(
                    controller: inputController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: appStateModel.blocks.localeText.searchProducts,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Circular',
                      ),
                      //fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).inputDecorationTheme.fillColor : Colors.white,
                      filled: true,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Theme.of(context).focusColor, width: 0,),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Theme.of(context).focusColor, width: 0,),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Theme.of(context).focusColor, width: 0,),
                      ),
                      contentPadding: EdgeInsets.all(6),
                      prefixIcon: Icon(
                        FontAwesomeIcons.search,
                        size: 18,
                          color: Theme.of(context).focusColor
                      ),
                      suffix: inputController.text.isNotEmpty ? InkWell(
                        onTap: () {
                          inputController.clear();
                          setState(() {});
                          },
                          child: Icon(FlutterIcons.ios_close_ion, size: 16, color: Theme.of(context).hintColor,)
                      ) : Container(
                        width: 4,
                        height: 4,
                      ),
                    ),
                    onChanged: (value) {
                      _onSearchChanged();
                    },
                  ),
                ),
              ),
            ),
            Container(
              child: InkWell(
                onTap: Navigator.of(context).pop,
                child: Text(appStateModel.blocks.localeText.cancel, style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                  color: Theme.of(context).hintColor,//Theme.of(context).primaryIconTheme.color,//Theme.of(context).hintColor,
                )),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<bool>(
        stream: widget.searchBloc.searchLoading,
        builder: (context, snapshotLoading) {
          return StreamBuilder<List<Product>>(
            stream: widget.searchBloc.searchResults,
            builder: (context, AsyncSnapshot<List<Product>> snapshot) {
              if(snapshotLoading.hasData && snapshotLoading.data) {
                return Center(child: CircularProgressIndicator());
              }
              else if(snapshot.hasData && inputController.text.isNotEmpty) {
                if(snapshot.data.length == 0) {
                  return Center(child: Text('NO RESULTS!'));
                }
                return buildProductList(snapshot, context);
              } else if(snapshot.hasData && snapshot.data.length == 0) {
                return Center(
                    child: Text('Please type something to search')
                );
              } else return Center(child: Container());
            },
          );
        },
      ),
    );
  }

  Widget buildProductList(snapshot, context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [ProductGrid(products: snapshot.data)],
    );
  }

}