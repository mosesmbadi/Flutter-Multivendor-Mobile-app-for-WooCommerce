import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../../config.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';
import 'attributes.dart';
import 'select_categories.dart';

class AddVendorProduct extends StatefulWidget {
  final VendorBloc vendorBloc;
  AddVendorProduct({Key key, this.vendorBloc}) : super(key: key);
  @override
  _AddVendorProductState createState() => _AddVendorProductState();
}

class _AddVendorProductState extends State<AddVendorProduct> {
  VendorProduct product = new VendorProduct();
  AppStateModel appStateModel = AppStateModel();
  final _formKey = GlobalKey<FormState>();
  Config config = Config();

  File imageFile;
  bool isImageUploading = false;

  @override
  void initState() {
    super.initState();
    product.type = 'simple';
    product.status = 'publish';
    product.catalogVisibility = 'visible';
    product.taxStatus = 'taxable';
    product.stockStatus = 'instock';
    product.backOrders = 'no';
    product.images = List<ProductImage>();
    product.categories = List<ProductCategory>();
    product.attributes = List<Attribute>();
  }

  void handleTypeValueChanged(String value) {
    setState(() {
      product.type = value;
    });
  }

  void handleStatusTypeValueChanged(String value) {
    setState(() {
      product.status = value;
    });
  }

  void handleCatalogVisibilityTypeValueChanged(String value) {
    setState(() {
      product.catalogVisibility = value;
    });
  }

  void handleStockStatusValueChanged(String value) {
    setState(() {
      product.stockStatus = value;
    });
  }

  void handleBackOrdersValueChanged(String value) {
    setState(() {
      product.backOrders = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appStateModel.blocks.localeText.product),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: appStateModel.blocks.localeText.product +
                            ' ' +
                            appStateModel.blocks.localeText.name,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return appStateModel.blocks.localeText.pleaseEnter +
                              ' ' +
                              appStateModel.blocks.localeText.product +
                              ' ' +
                              appStateModel.blocks.localeText.name;
                        }
                      },
                      onSaved: (val) => setState(() => product.name = val),
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => _choose(),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.all(4.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                        ),
                        product.images != null && product.images.length >= 0
                            ? GridView.builder(
                                shrinkWrap: true,
                                itemCount: product.images.length + 1,
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4),
                                itemBuilder: (BuildContext context, int index) {
                                  if (product.images.length != index) {
                                    return Card(
                                        clipBehavior: Clip.antiAlias,
                                        margin: EdgeInsets.all(4.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Image.network(
                                            product.images[index].src,
                                            fit: BoxFit.cover));
                                  } else if (product.images.length == index &&
                                      isImageUploading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return Container();
                                  }
                                })
                            : Container(),
                      ],
                    ),
                    _buildCategoryTile(),
                    _buildAttributesTile(),
                    const SizedBox(height: 16.0),
                    Text(appStateModel.blocks.localeText.type,
                        style: Theme.of(context).textTheme.subtitle1),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'simple',
                          groupValue: product.type,
                          onChanged: handleTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.simple,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'grouped',
                          groupValue: product.type,
                          onChanged: handleTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.grouped,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(children: <Widget>[
                      Radio<String>(
                        value: 'external',
                        groupValue: product.type,
                        onChanged: handleTypeValueChanged,
                      ),
                      new Text(
                        appStateModel.blocks.localeText.external,
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio<String>(
                        value: 'variable',
                        groupValue: product.type,
                        onChanged: handleTypeValueChanged,
                      ),
                      new Text(
                        appStateModel.blocks.localeText.variable,
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ]),
                    const SizedBox(height: 16.0),
                    Text(appStateModel.blocks.localeText.status,
                        style: Theme.of(context).textTheme.subtitle1),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'draft',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.draft,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'pending',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.pending,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'private',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.private,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'publish',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.publish,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(appStateModel.blocks.localeText.catalogVisibility,
                        style: Theme.of(context).textTheme.subtitle1),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'visible',
                          groupValue: product.catalogVisibility,
                          onChanged: handleCatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.visible,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'catalog',
                          groupValue: product.catalogVisibility,
                          onChanged: handleCatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.catalog,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'search',
                          groupValue: product.catalogVisibility,
                          onChanged: handleCatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.search,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'hidden',
                          groupValue: product.catalogVisibility,
                          onChanged: handleCatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.hidden,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(appStateModel.blocks.localeText.stockStatus,
                        style: Theme.of(context).textTheme.subtitle1),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'instock',
                          groupValue: product.stockStatus,
                          onChanged: handleStockStatusValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.inStock,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'outofstock',
                          groupValue: product.stockStatus,
                          onChanged: handleStockStatusValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.outOfStock,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    /*Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'onbackorder',
                          groupValue: product.stockStatus,
                          onChanged: handleStockStatusValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.backOrder,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),*/
                    const SizedBox(height: 16.0),
                    Text(appStateModel.blocks.localeText.backOrder,
                        style: Theme.of(context).textTheme.subtitle1),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'no',
                          groupValue: product.backOrders,
                          onChanged: handleBackOrdersValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.no,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'notify ',
                          groupValue: product.backOrders,
                          onChanged: handleBackOrdersValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.notify,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'yes',
                          groupValue: product.backOrders,
                          onChanged: handleBackOrdersValueChanged,
                        ),
                        new Text(
                          appStateModel.blocks.localeText.yes,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: appStateModel.blocks.localeText.weight),
                      /* validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter weight';
                        }
                      },*/
                      onSaved: (val) => setState(() => product.weight),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: appStateModel.blocks.localeText.sku,
                      ),
                      onSaved: (val) => setState(() => product.sku = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText:
                              appStateModel.blocks.localeText.description),
                      onSaved: (val) =>
                          setState(() => product.shortDescription = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: appStateModel.blocks.localeText.long +
                              ' ' +
                              appStateModel.blocks.localeText.description),
                      onSaved: (val) =>
                          setState(() => product.description = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText:
                              appStateModel.blocks.localeText.regularPrice),
                      onSaved: (val) {
                        setState(() {
                          product.regularPrice = val;
                          product.price = val;
                        });
                      }
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText:
                              appStateModel.blocks.localeText.salesPrice),
                      onSaved: (val) => setState(() => product.salePrice = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText:
                              appStateModel.blocks.localeText.purchaseNote),
                      onSaved: (val) =>
                          setState(() => product.purchaseNote = val),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              widget.vendorBloc.addProduct(product);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(appStateModel.blocks.localeText.submit),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _choose() async {
    // set state image uploading true
    //imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      _upload();
    }
  }

  void _upload() async {
    setState(() {
      isImageUploading = true;
    });
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(config.url +
            "/wp-admin/admin-ajax.php?action=mstoreapp_upload_image"));
    var pic = await http.MultipartFile.fromPath("file", imageFile.path);
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    Map<String, dynamic> fileUpload = jsonDecode(responseString);
    FileUploadResponse uploadedFile = FileUploadResponse.fromJson(fileUpload);


    if (uploadedFile.url != null) {
      ProductImage picture = ProductImage();
      picture.src = uploadedFile.url;
      setState(() {
        product.images.add(picture);
        isImageUploading = false;
      });
    }
  }

  _buildCategoryTile() {
    String option = '';
    product.categories.forEach((value) =>
        {option = option.isEmpty ? value.name : option + ', ' + value.name});
    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      onTap: () async {
        final data = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectCategories(product: product)));
        setState(() => product);
      },
      title: Text(appStateModel.blocks.localeText.categories),
      //isThreeLine: true,
      subtitle: option.isNotEmpty
          ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis)
          : null,
      trailing: Icon(CupertinoIcons.forward),
    );
  }

  _buildAttributesTile() {
    String option = '';
    product.attributes.forEach((value) {
      if(value.options.length != 0) {
        option = option.isEmpty ? value.name : option + ', ' + value.name;
      }
    });
    return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        title: Text(appStateModel.blocks.localeText.attributes),
        //dense: true,
        trailing: Icon(CupertinoIcons.forward),
        subtitle: option.isNotEmpty
            ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        onTap: () async {
          final data = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectAttributes(
                vendorBloc: widget.vendorBloc,
                product: product,
              ),
            ),
          );
          setState(() => product);
        });
  }
}

class FileUploadResponse {
  final String url;

  FileUploadResponse(this.url);

  FileUploadResponse.fromJson(Map<String, dynamic> json) : url = json['url'];

  Map<String, dynamic> toJson() => {
        'url': url,
      };
}
