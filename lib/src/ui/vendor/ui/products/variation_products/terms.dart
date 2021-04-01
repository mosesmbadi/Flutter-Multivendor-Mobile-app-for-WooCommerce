import 'package:flutter/material.dart';

import '../../../../../blocs/vendor/attribute_bloc.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/product_attribute_model.dart';
import '../../../../../models/vendor/product_variation_model.dart';

class TermsPage extends StatefulWidget {
  final AttributeBloc attributeBloc;
  final ProductAttribute productAttribute;
  final ProductVariation variationProduct;

  TermsPage(
      {Key key,
      this.productAttribute,
      this.variationProduct,
      this.attributeBloc})
      : super(key: key);
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  AppStateModel _appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
    widget.attributeBloc.fetchAllTerms(widget.productAttribute.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_appStateModel.blocks.localeText.options),
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
    return ListTile(
      onTap: () => _onAttributesTermsTap(attributesTerm),
      title: Text(attributesTerm.name),
      trailing: Checkbox(
        value: widget.variationProduct.attributes != null &&
            widget.variationProduct.attributes
                .any((item) => item.option == attributesTerm.name),
        onChanged: (bool value) {
          setState(() {
            //monVal = value;
          });
        },
      ),
    );
  }

  _onAttributesTermsTap(AttributeTerms term) {
    VariationAttribute attribute = new VariationAttribute();
    attribute.id = widget.productAttribute.id;
    attribute.name = widget.productAttribute.name;
    attribute.option = term.name;
    if (!widget.variationProduct.attributes
        .any((item) => item.option == term.name)) {
      setState(() {
        widget.variationProduct.attributes.add(attribute);
      });
    } else {
      setState(() {
        widget.variationProduct.attributes
            .removeWhere((item) => item.option == term.name);
      });
    }
  }
}
