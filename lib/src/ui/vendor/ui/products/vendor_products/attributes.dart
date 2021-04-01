import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../blocs/vendor/attribute_bloc.dart';
import '../../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/product_attribute_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';
import 'terms.dart';

class SelectAttributes extends StatefulWidget {
  VendorBloc vendorBloc;
  VendorProduct product;
  AttributeBloc attributeBloc = AttributeBloc();

  SelectAttributes({Key key, this.vendorBloc, this.product}) : super(key: key);
  @override
  _SelectAttributesState createState() => _SelectAttributesState();
}

class _SelectAttributesState extends State<SelectAttributes> {
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
    if (widget.product.attributes == null) widget.product.attributes = [];
    widget.attributeBloc.fetchAllAttributes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appStateModel.blocks.localeText.attributes),
        ),
        body: StreamBuilder<List<ProductAttribute>>(
            stream: widget.attributeBloc.allAttribute,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(slivers: _buildList(snapshot));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  buildBody(BuildContext ctxt, ProductAttribute productAttribute) {
    String option = '';
    widget.product.attributes.forEach((value) {
      if (value.id == productAttribute.id)
        value.options.forEach(
            (name) => option = option.isEmpty ? name : option + ', ' + name);
    });
    return ListTile(
      onTap: () async {
        final data = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AttributeOptionsPage(
                  product: widget.product,
                  productAttribute: productAttribute,
                  attributeBloc: widget.attributeBloc)));
        setState(() => widget.product);
      },
      title: Text(productAttribute.name),
      //isThreeLine: true,
      subtitle: option.isNotEmpty
          ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis)
          : null,
      trailing: Icon(CupertinoIcons.forward),
    );
  }

  _buildList(AsyncSnapshot<List<ProductAttribute>> snapshot) {
    List<Widget> list = new List<Widget>();
    list.add(
      SliverFixedExtentList(
        itemExtent: 56, // I'm forcing item heights
        delegate: SliverChildBuilderDelegate(
          (context, index) => buildBody(context, snapshot.data[index]),
          childCount: snapshot.data.length,
        ),
      ),
    );
    return list;
  }
}
