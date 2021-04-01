//import 'package:app/src/models/vendor/vendor_product_model.dart';
import 'package:flutter/material.dart';

import '../../../../../blocs/vendor/attribute_bloc.dart';
import '../../../../../models/vendor/product_attribute_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';

class AttributeOptionsPage extends StatefulWidget {
  final AttributeBloc attributeBloc;
  final ProductAttribute productAttribute;
  final VendorProduct product;

  AttributeOptionsPage(
      {Key key,
      this.productAttribute,
      this.product,
      this.attributeBloc})
      : super(key: key);
  @override
  _AttributeOptionsPageState createState() => _AttributeOptionsPageState();
}

class _AttributeOptionsPageState extends State<AttributeOptionsPage> {

  @override
  void initState() {
    super.initState();
    widget.attributeBloc.fetchAllTerms(widget.productAttribute.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.productAttribute.name),
        ),
        body: StreamBuilder<List<AttributeTerms>>(
            stream: widget.attributeBloc.allTerms,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext ctxt, int index) =>
                          buildBody(ctxt, snapshot.data[index]))
                  : Center(child: CircularProgressIndicator());
            }));
  }

  buildBody(BuildContext ctxt, AttributeTerms attributesTerm) {
    var contains = false;

    if(widget.product.attributes.any((item) => item.id == widget.productAttribute.id)) {
      if(widget.product.attributes.singleWhere((item) => item.id == widget.productAttribute.id).options.contains(attributesTerm.name)) {
        contains = true;
      }
    }
    return ListTile(
      onTap: () => _onAttributesTermsTap(attributesTerm),
      title: Text(attributesTerm.name),
      trailing: Checkbox(
        value: contains,
        onChanged: (bool value) =>
          _onAttributesTermsTap(attributesTerm),
      ),
    );
  }

  _onAttributesTermsTap(AttributeTerms term) {
    print('fdsafdsa');
    if(widget.product.attributes.any((item) => item.id == widget.productAttribute.id)) {
      if(widget.product.attributes.singleWhere((item) => item.id == widget.productAttribute.id).options.contains(term.name)) {
        setState(() {
          widget.product.attributes.singleWhere((item) => item.id == widget.productAttribute.id).options.remove(term.name);
        });
      } else {
        setState(() {
          widget.product.attributes.singleWhere((item) => item.id == widget.productAttribute.id).options.add(term.name);
        });
      }
    } else {
      Attribute attribute = Attribute();
      attribute.options = List<String>();
      attribute.id = widget.productAttribute.id;
      attribute.name = widget.productAttribute.name;
      attribute.options.add(term.name);
      setState(() {
        widget.product.attributes.add(attribute);
      });
    }
  }
}
