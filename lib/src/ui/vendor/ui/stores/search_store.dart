import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../models/app_state_model.dart';
import '../../../../models/vendor/search_store_state_model.dart';
import '../../../../models/vendor/store_model.dart';
import 'store_list/store_list.dart';

class SearchStores extends StatefulWidget {
  final SearchStoreStateModel model = SearchStoreStateModel();

  @override
  _SearchStoresState createState() => _SearchStoresState();
}

class _SearchStoresState extends State<SearchStores> {

  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
    widget.model.stores = [];
    widget.model.filter['search'] = '';
        inputController.addListener(_onSearchChanged);
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void dispose() {
    inputController.removeListener(_onSearchChanged);
    inputController.dispose();
    _scrollController.removeListener(_loadMoreItems);
    _scrollController.dispose();
    _debounce.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    widget.model.filter['search'] = inputController.text;
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(inputController.text.isNotEmpty) {
        widget.model.getAllStores();
      } else {
        widget.model.emptyStores();
      }
    });
  }

  Timer _debounce;

  ScrollController _scrollController = new ScrollController();
  TextEditingController inputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: buildTitle(context),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await widget.model.refresh();
            return;
          },
          child: ScopedModel<SearchStoreStateModel>(
              model: widget.model,
              child: ScopedModelDescendant<SearchStoreStateModel>(
                  builder: (context, child, model) {
                if ((model.stores != null && model.stores.isNotEmpty)) {
                  return CustomScrollView(
                        controller: _scrollController,
                        slivers: buildListOfBlocks(model.stores, model),
                      );
                } else if(model.loading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              })),
        ));
  }

  Row buildTitle(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: TextField(
                    controller: inputController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: appStateModel.blocks.localeText.searchStores,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Circular',
                      ),
                      //fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).inputDecorationTheme.fillColor : Colors.white,
                      filled: true,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Theme.of(context).focusColor,
                          width: 0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Theme.of(context).focusColor,
                          width: 0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Theme.of(context).focusColor,
                          width: 0,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(6),
                      prefixIcon: Icon(FontAwesomeIcons.search,
                          size: 18, color: Theme.of(context).focusColor),
                      suffix: inputController.text.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                inputController.clear();
                                setState(() {});
                              },
                              child: Icon(
                                FlutterIcons.ios_close_ion,
                                size: 16,
                                color: Theme.of(context).hintColor,
                              ))
                          : Container(
                              width: 4,
                              height: 4,
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: InkWell(
                onTap: Navigator.of(context).pop,
                child: Text(appStateModel.blocks.localeText.cancel,
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Theme.of(context).hintColor,//Theme.of(context).hintColor,
                          )),
              ),
            ),
          ],
        );
  }

  List<Widget> buildListOfBlocks(
      List<StoreModel> stores, SearchStoreStateModel model) {
    List<Widget> list = new List<Widget>();
    list.add(StoresList(stores: stores));
    list.add(SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate([
              model.hasMoreItems
                  ? Container(
                  height: 60, child: Center(child: CircularProgressIndicator()))
                  : Container()
            ]))));
    return list;
  }

  _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        widget.model.hasMoreItems) {
      widget.model.loadMoreStores();
    }
  }
}
