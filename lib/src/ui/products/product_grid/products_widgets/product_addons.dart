import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/product_addons_model.dart';
import 'package:intl/intl.dart';
import './../../../../models/product_model.dart';
import '../../../../functions.dart';

class ProductAddons extends StatefulWidget {

  final Product product;
  final GlobalKey<FormState> addonFormKey;
  final Map<String, dynamic> addOnsFormData;

  const ProductAddons({Key key, this.product, this.addOnsFormData, this.addonFormKey}) : super(key: key);

  @override
  _ProductAddonsState createState() => _ProductAddonsState();
}

class _ProductAddonsState extends State<ProductAddons> {

  //final addonFormKey = GlobalKey<FormState>();
  final appStateModel = AppStateModel();
  NumberFormat formatter;
  bool excludeGlobal = false;
  List<AddonField> addonFields = [];

  @override
  void initState() {
    super.initState();

    if(widget.product.metaData.any((element) => element.key == '_product_addons_exclude_global')) {
      excludeGlobal = widget.product.metaData.singleWhere((element) => element.key == '_product_addons_exclude_global').value == '1';
    }

    for(var value in widget.product.metaData) {
      if(value.key == '_product_addons'){
        final jsonStr = json.encode(value);
        final jsondata  = json.decode(jsonStr);
        addonFields = List<AddonField>.from(jsondata["value"].map((x) => AddonField.fromJson(x)));
      }
    }

    formatter = NumberFormat.simpleCurrency(
        decimalDigits: 2, name: AppStateModel().selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return SliverToBoxAdapter(
            child: Form(
              key: widget.addonFormKey,
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: ListView(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  children: buildList(model),
                ),
              ),
            )
        );
      }
    );
  }

  buildList(AppStateModel model) {

    var productLevelAddonIndex = 0;

    List<Widget> list = new List<Widget>();

    TextStyle headingStyle = Theme.of(context).textTheme.headline6;

    if(model.productAddons.length > 0 && !excludeGlobal)
    for (var i = 0; i < model.productAddons.length; i++) {

      List<String> cateogryIds = [];
      widget.product.categories.forEach((element) {
        cateogryIds.add(element.toString());
      });

      bool inRestricted = false;
      for(var value in model.productAddons[i].restrictToCategories.keys) {
        if(cateogryIds.contains(value)) {
          inRestricted = true;
        }
      }


      if(model.productAddons[i].restrictToCategories.keys.length == 0 || inRestricted)
      for (var f = 0; f < model.productAddons[i].fields.length; f++) {

        if(model.productAddons[i].fields[f].type == 'custom') {
          if(model.productAddons[i].fields[f].options.length > 0) {
            list.add(
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(model.productAddons[i].fields[f].name, style: headingStyle),
                  subtitle: Text(model.productAddons[i].fields[f].description),
                )
            );
            for (var o = 0; o < model.productAddons[i].fields[f].options.length; o++) {
              list.add(
                  Container(
                    height: 50,
                    //color: Colors.green,
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          widget.addOnsFormData[_getKey(model.productAddons, i, f, o)] = value;
                        });
                      },
                      validator: (value) {
                        if (model.productAddons[i].fields[f].required == 1 && value.isEmpty) {
                          return appStateModel.blocks.localeText.pleaseEnterFirstName;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: model.productAddons[i].fields[f].options[o].label + ' ' + _getPrice(model.productAddons[i].fields[f].options[o]),
                      ),
                    ),
                  )
              );
            }
          }
        }

        if(model.productAddons[i].fields[f].type == 'custom_textarea' || model.productAddons[i].fields[f].type == 'custom_text') {
          if(model.productAddons[i].fields[f].options.length > 0) {
            list.add(
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(model.productAddons[i].fields[f].name, style: headingStyle),
                  subtitle: Text(model.productAddons[i].fields[f].description),
                )
            );
            for (var o = 0; o < model.productAddons[i].fields[f].options.length; o++) {
              list.add(
                  Container(
                    child: TextFormField(
                      maxLength: 60,
                      maxLines: 4,
                      onSaved: (value) {
                        setState(() {
                          widget.addOnsFormData[_getKey(model.productAddons, i, f, o)] = value;
                        });
                      },
                      validator: (value) {
                        if (model.productAddons[i].fields[f].required == 1 && value.isEmpty) {
                          return appStateModel.blocks.localeText.pleaseEnterFirstName;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: model.productAddons[i].fields[f].options[o].label + ' ' + _getPrice(model.productAddons[i].fields[f].options[o]),
                      ),
                    ),
                  )
              );
            }
          }
        }

        if(model.productAddons[i].fields[f].type == 'custom_email') {
          if(model.productAddons[i].fields[f].options.length > 0) {
            list.add(
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(model.productAddons[i].fields[f].name, style: headingStyle),
                  subtitle: Text(model.productAddons[i].fields[f].description),
                )
            );
            for (var o = 0; o < model.productAddons[i].fields[f].options.length; o++) {
              list.add(
                  Container(
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          widget.addOnsFormData[_getKey(model.productAddons, i, f, o)] = value;
                        });
                      },
                      validator: (value) {
                        if (model.productAddons[i].fields[f].required == 1 && value.isEmpty) {
                          return appStateModel.blocks.localeText.pleaseEnterFirstName;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: model.productAddons[i].fields[f].options[o].label + ' ' + _getPrice(model.productAddons[i].fields[f].options[o]),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  )
              );
            }
          }
        }

        if(model.productAddons[i].fields[f].type == 'custom_digits_only') {
          if(model.productAddons[i].fields[f].options.length > 0) {
            list.add(
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(model.productAddons[i].fields[f].name, style: headingStyle),
                  subtitle: Text(model.productAddons[i].fields[f].description),
                )
            );
            for (var o = 0; o < model.productAddons[i].fields[f].options.length; o++) {
              list.add(
                  Container(
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          widget.addOnsFormData[_getKey(model.productAddons, i, f, o)] = value;
                        });
                      },
                      validator: (value) {
                        if (model.productAddons[i].fields[f].required == 1 && value.isEmpty) {
                          return appStateModel.blocks.localeText.pleaseEnterFirstName;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: model.productAddons[i].fields[f].options[o].label + ' ' + _getPrice(model.productAddons[i].fields[f].options[o]),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  )
              );
            }
          }
        }

        if(model.productAddons[i].fields[f].type == 'input_multiplier') {
          if(model.productAddons[i].fields[f].options.length > 0) {
            list.add(
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(model.productAddons[i].fields[f].name, style: headingStyle),
                  subtitle: Text(model.productAddons[i].fields[f].description),
                )
            );
            for (var o = 0; o < model.productAddons[i].fields[f].options.length; o++) {
              list.add(
                  Container(
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          widget.addOnsFormData[_getKey(model.productAddons, i, f, o)] = value;
                        });
                      },
                      validator: (value) {
                        if (model.productAddons[i].fields[f].required == 1 && value.isEmpty) {
                          return appStateModel.blocks.localeText.pleaseEnterFirstName;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: model.productAddons[i].fields[f].options[o].label + ' ' + _getPrice(model.productAddons[i].fields[f].options[o]),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  )
              );
            }
          }
        }

        if(model.productAddons[i].fields[f].type == 'custom_price') {
          if(model.productAddons[i].fields[f].options.length > 0) {
            list.add(
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(model.productAddons[i].fields[f].name, style: headingStyle),
                  subtitle: Text(model.productAddons[i].fields[f].description),
                )
            );
            for (var o = 0; o < model.productAddons[i].fields[f].options.length; o++) {
              list.add(
                  Container(
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          widget.addOnsFormData[_getKey(model.productAddons, i, f, o)] = value;
                        });
                      },
                      validator: (value) {
                        if (model.productAddons[i].fields[f].required == 1 && value.isEmpty) {
                          return appStateModel.blocks.localeText.pleaseEnterFirstName;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: model.productAddons[i].fields[f].options[o].label,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  )
              );
            }
          }
        }

        if(model.productAddons[i].fields[f].type == 'checkbox' && model.productAddons[i].fields[f].display == 'select') {
          list.add(
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(model.productAddons[i].fields[f].name, style: headingStyle),
                subtitle: Text(model.productAddons[i].fields[f].description),
              )
          );

          for (var o = 0; o < model.productAddons[i].fields[f].options.length; o++) {

            list.add(
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: widget.addOnsFormData[_getCheckBoxSelectKey(model.productAddons, i, f, o)] == model.productAddons[i].fields[f].options[o].label.toLowerCase().replaceAll(' ', '-'),
                onChanged: (bool value) {
                  if(value) {
                    setState(() {
                      widget.addOnsFormData[_getCheckBoxSelectKey(model.productAddons, i, f, o)] = model.productAddons[i].fields[f].options[o].label.toLowerCase().replaceAll(' ', '-'); //*** For Lower version of addons ***/
                    });
                  } else {
                    setState(() {
                      widget.addOnsFormData.remove(_getCheckBoxSelectKey(model.productAddons, i, f, o));
                    });
                  }
                },
                title: Row(
                  children: [
                    Text(
                        model.productAddons[i].fields[f].options[o].label
                    ),
                    SizedBox(width: 6),
                    Text(
                        _getPrice(model.productAddons[i].fields[f].options[o])
                    ),
                  ],
                ),
              ),
            );

          }
        }

        if(model.productAddons[i].fields[f].type == 'multiple_choice' && model.productAddons[i].fields[f].display == 'select') {
          list.add(
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(model.productAddons[i].fields[f].name, style: headingStyle),
                subtitle: Text(model.productAddons[i].fields[f].description),
              )
          );

          for (var o = 0; o < model.productAddons[i].fields[f].options.length; o++) {

            list.add(
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: widget.addOnsFormData[_getCheckBoxKey(model.productAddons, i, f, o)] == model.productAddons[i].fields[f].options[o].label.toLowerCase().replaceAll(' ', '-') + '-' + (o + 1).toString(),
                onChanged: (bool value) {
                  if(value) {
                    setState(() {
                      widget.addOnsFormData[_getCheckBoxKey(model.productAddons, i, f, o)] = model.productAddons[i].fields[f].options[o].label.toLowerCase().replaceAll(' ', '-') + '-' + (o + 1).toString(); //*** For Lower version of addons ***/
                    });
                  } else {
                    setState(() {
                      widget.addOnsFormData.remove(_getCheckBoxKey(model.productAddons, i, f, o));
                    });
                  }
                },
                title: Row(
                  children: [
                    Text(
                        model.productAddons[i].fields[f].options[o].label
                    ),
                    SizedBox(width: 6),
                    Text(
                        _getPrice(model.productAddons[i].fields[f].options[o])
                    ),
                  ],
                ),
              ),
            );

          }
        }

        if(model.productAddons[i].fields[f].type == 'multiple_choice' && model.productAddons[i].fields[f].display == 'radiobutton') {
          list.add(
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(model.productAddons[i].fields[f].name, style: headingStyle),
                subtitle: Text(model.productAddons[i].fields[f].description),
              )
          );
          for (var o = 0; o < model.productAddons[i].fields[f].options.length; o++) {
            list.add(
              RadioListTile<String>(
                title: Row(
                  children: [
                    Text(
                        model.productAddons[i].fields[f].options[o].label
                    ),
                    SizedBox(width: 6),
                    Text(
                        _getPrice(model.productAddons[i].fields[f].options[o])
                    ),
                  ],
                ),
                value: model.productAddons[i].fields[f].options[o].label.toLowerCase().replaceAll(' ', '-') + '-' + (o + 1).toString(),
                groupValue: widget.addOnsFormData[_getRadioKey(model.productAddons, i, f)],
                onChanged: (String value) {
                  setState(() {
                    widget.addOnsFormData[_getRadioKey(model.productAddons, i, f)] = value;
                  });
                },
              ),
            );
          }
        }

        if(model.productAddons[i].fields[f].type == 'select') {

          if(widget.addOnsFormData[_getSelectKey(model.productAddons, i, f)] == null) {
              widget.addOnsFormData[_getSelectKey(model.productAddons, i, f)] = model.productAddons[i].fields[f].options.first.label.toLowerCase().replaceAll(' ', '-') + '-1';
          }

          list.add(
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(model.productAddons[i].fields[f].name, style: headingStyle),
                subtitle: Text(model.productAddons[i].fields[f].description),
              )
          );

          list.add(
            DropdownButton<AddonOption>(
              value: model.productAddons[i].fields[f].options.first,
              hint: Text(model.productAddons[i].fields[f].name),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Theme.of(context).dividerColor,
              ),
              onChanged: (AddonOption value) {
                setState(() {
                  widget.addOnsFormData[_getRadioKey(model.productAddons, i, f)] = value.label.toLowerCase().replaceAll(' ', '-') + '-' + (model.productAddons[i].fields[f].options.indexOf(value) + 1).toString();
                });
              },
              items: model.productAddons[i].fields[f].options
                  .map<DropdownMenuItem<AddonOption>>(
                      (value) {
                    return DropdownMenuItem<AddonOption>(
                      value: value,
                      child: Row(
                        children: [
                          Text(value.label),
                          SizedBox(width: 6),
                          Text(
                              _getPrice(value)
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          );
        }
      }
    }

    if(addonFields.length > 0)
    for (var f = 0; f < addonFields.length; f++) {

      if(addonFields[f].type == 'custom') {
        if(addonFields[f].options.length > 0) {
          list.add(
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(addonFields[f].name, style: headingStyle),
                subtitle: Text(addonFields[f].description),
              )
          );
          for (var o = 0; o < addonFields[f].options.length; o++) {
            list.add(
                Container(
                  height: 50,
                  //color: Colors.green,
                  child: TextFormField(
                    onSaved: (value) {
                      setState(() {
                        widget.addOnsFormData[_getProductKey(addonFields[f], f, o)] = value;
                      });
                    },
                    validator: (value) {
                      if (addonFields[f].required == 1 && value.isEmpty) {
                        return appStateModel.blocks.localeText.pleaseEnterFirstName;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: addonFields[f].options[o].label + ' ' + _getPrice(addonFields[f].options[o]),
                    ),
                  ),
                )
            );
          }
        }
      }

      if(addonFields[f].type == 'custom_textarea' || addonFields[f].type == 'custom_text') {
        if(addonFields[f].options.length > 0) {
          list.add(
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(addonFields[f].name, style: headingStyle),
                subtitle: Text(addonFields[f].description),
              )
          );
          for (var o = 0; o < addonFields[f].options.length; o++) {
            list.add(
                Container(
                  child: TextFormField(
                    maxLength: addonFields[f].options[o].max,
                    maxLines: 4,
                    onSaved: (value) {
                      setState(() {
                        widget.addOnsFormData[_getProductKey(addonFields[f], f, o)] = value;
                      });
                    },
                    validator: (value) {
                      if (addonFields[f].required == 1 && value.isEmpty) {
                        return appStateModel.blocks.localeText.pleaseEnterFirstName;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: addonFields[f].options[o].label + ' ' + _getPrice(addonFields[f].options[o]),
                    ),
                  ),
                )
            );
          }
        }
      }

      if(addonFields[f].type == 'custom_email') {
        if(addonFields[f].options.length > 0) {
          list.add(
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(addonFields[f].name, style: headingStyle),
                subtitle: Text(addonFields[f].description),
              )
          );
          for (var o = 0; o < addonFields[f].options.length; o++) {
            list.add(
                Container(
                  child: TextFormField(
                    onSaved: (value) {
                      setState(() {
                        widget.addOnsFormData[_getProductKey(addonFields[f], f, o)] = value;
                      });
                    },
                    validator: (value) {
                      if (addonFields[f].required == 1 && value.isEmpty) {
                        return appStateModel.blocks.localeText.pleaseEnterFirstName;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: addonFields[f].options[o].label + ' ' + _getPrice(addonFields[f].options[o]),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                )
            );
          }
        }
      }

      if(addonFields[f].type == 'custom_digits_only') {
        if(addonFields[f].options.length > 0) {
          list.add(
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(addonFields[f].name, style: headingStyle),
                subtitle: Text(addonFields[f].description),
              )
          );
          for (var o = 0; o < addonFields[f].options.length; o++) {
            list.add(
                Container(
                  child: TextFormField(
                    onSaved: (value) {
                      setState(() {
                        widget.addOnsFormData[_getProductKey(addonFields[f], f, o)] = value;
                      });
                    },
                    validator: (value) {
                      if (addonFields[f].required == 1 && value.isEmpty) {
                        return appStateModel.blocks.localeText.pleaseEnterFirstName;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: addonFields[f].options[o].label + ' ' + _getPrice(addonFields[f].options[o]),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                )
            );
          }
        }
      }

      if(addonFields[f].type == 'input_multiplier') {
        if(addonFields[f].options.length > 0) {
          list.add(
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(addonFields[f].name, style: headingStyle),
                subtitle: Text(addonFields[f].description),
              )
          );
          for (var o = 0; o < addonFields[f].options.length; o++) {
            list.add(
                Container(
                  child: TextFormField(
                    onSaved: (value) {
                      setState(() {
                        widget.addOnsFormData[_getProductKey(addonFields[f], f, o)] = value;
                      });
                    },
                    validator: (value) {
                      if (addonFields[f].required == 1 && value.isEmpty) {
                        return appStateModel.blocks.localeText.pleaseEnterFirstName;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: addonFields[f].options[o].label + ' ' + _getPrice(addonFields[f].options[o]),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                )
            );
          }
        }
      }

      if(addonFields[f].type == 'custom_price') {
        if(addonFields[f].options.length > 0) {
          list.add(
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(addonFields[f].name, style: headingStyle),
                subtitle: Text(addonFields[f].description),
              )
          );
          for (var o = 0; o < addonFields[f].options.length; o++) {
            list.add(
                Container(
                  child: TextFormField(
                    onSaved: (value) {
                      setState(() {
                        widget.addOnsFormData[_getProductKey(addonFields[f], f, o)] = value;
                      });
                    },
                    validator: (value) {
                      if (addonFields[f].required == 1 && value.isEmpty) {
                        return appStateModel.blocks.localeText.pleaseEnterFirstName;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: addonFields[f].options[o].label,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                )
            );
          }
        }
      }

      if(addonFields[f].type == 'checkbox' && addonFields[f].display == 'select') {
        list.add(
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(addonFields[f].name, style: headingStyle),
              subtitle: Text(addonFields[f].description),
            )
        );

        for (var o = 0; o < addonFields[f].options.length; o++) {

          list.add(
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: widget.addOnsFormData[_getProductCheckBoxKey(addonFields[f], f, o)] == addonFields[f].options[o].label.toLowerCase().replaceAll(' ', '-'), // + '-' + (o + 1).toString()
              onChanged: (bool value) {
                if(value) {
                  setState(() {
                    widget.addOnsFormData[_getProductCheckBoxKey(addonFields[f], f, o)] = addonFields[f].options[o].label.toLowerCase().replaceAll(' ', '-'); // + '-' + (o + 1).toString()
                  });
                } else {
                  setState(() {
                    widget.addOnsFormData.remove(_getProductCheckBoxKey(addonFields[f], f, o));
                  });
                }
              },
              title: Row(
                children: [
                  Text(
                      addonFields[f].options[o].label
                  ),
                  SizedBox(width: 6),
                  Text(
                      _getPrice(addonFields[f].options[o])
                  ),
                ],
              ),
            ),
          );

        }
      }

      if(addonFields[f].type == 'multiple_choice' && addonFields[f].display == 'select') {
        list.add(
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(addonFields[f].name, style: headingStyle),
              subtitle: Text(addonFields[f].description),
            )
        );

        for (var o = 0; o < addonFields[f].options.length; o++) {

          list.add(
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: widget.addOnsFormData[_getProductCheckBoxSelectKey(addonFields[f], f, o)] == addonFields[f].options[o].label.toLowerCase().replaceAll(' ', '-') + '-' + (o + 1).toString(),
              onChanged: (bool value) {
                if(value) {
                  setState(() {
                    widget.addOnsFormData[_getProductCheckBoxSelectKey(addonFields[f], f, o)] = addonFields[f].options[o].label.toLowerCase().replaceAll(' ', '-') + '-' + (o + 1).toString();
                  });
                } else {
                  setState(() {
                    widget.addOnsFormData.remove(_getProductCheckBoxSelectKey(addonFields[f], f, o));
                  });
                }
              },
              title: Row(
                children: [
                  Text(
                      addonFields[f].options[o].label
                  ),
                  SizedBox(width: 6),
                  Text(
                      _getPrice(addonFields[f].options[o])
                  ),
                ],
              ),
            ),
          );

        }
      }


      if(addonFields[f].type == 'multiple_choice' && addonFields[f].display == 'radiobutton') {
        list.add(
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(addonFields[f].name, style: headingStyle),
              subtitle: Text(addonFields[f].description),
            )
        );
        for (var o = 0; o < addonFields[f].options.length; o++) {
          list.add(
            RadioListTile<String>(
              title: Row(
                children: [
                  Text(
                      addonFields[f].options[o].label
                  ),
                  SizedBox(width: 6),
                  Text(
                      _getPrice(addonFields[f].options[o])
                  ),
                ],
              ),
              value: addonFields[f].options[o].label.toLowerCase().replaceAll(' ', '-'),
              groupValue: widget.addOnsFormData[_getProductRadioKey(addonFields[f], f)],
              onChanged: (String value) {
                setState(() {
                  widget.addOnsFormData[_getProductRadioKey(addonFields[f], f)] = value;
                });
              },
            ),
          );
        }
      }

      if(addonFields[f].type == 'select') {

        if(widget.addOnsFormData[_getProductSelectKey(addonFields[f], f)] == null) {
          widget.addOnsFormData[_getProductSelectKey(addonFields[f], f)] = addonFields[f].options.first.label.toLowerCase().replaceAll(' ', '-') + '-1';
        }

        list.add(
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(addonFields[f].name, style: headingStyle),
              subtitle: Text(addonFields[f].description),
            )
        );

        list.add(
          DropdownButton<AddonOption>(
            value: addonFields[f].options.first,
            hint: Text(addonFields[f].name),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Theme.of(context).dividerColor,
            ),
            onChanged: (AddonOption value) {
              setState(() {
                widget.addOnsFormData[_getProductRadioKey(addonFields[f], f)] = value.label.toLowerCase().replaceAll(' ', '-') + '-' + (addonFields[f].options.indexOf(value) + 1).toString();
              });
            },
            items: addonFields[f].options
                .map<DropdownMenuItem<AddonOption>>(
                    (value) {
                  return DropdownMenuItem<AddonOption>(
                    value: value,
                    child: Row(
                      children: [
                        Text(value.label),
                        SizedBox(width: 6),
                        Text(
                            _getPrice(value)
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        );
      }
    }

    return list;
  }

  _getKey(List<ProductAddonsModel> productAddons, int i, int f, int o) {
    return 'addon-' + widget.product.id.toString() + '-' + productAddons[i].fields[f].name.toLowerCase().replaceAll(' ', '-') + '-' + f.toString(); /* + '[' + productAddons[i].fields[f].options[o].label.toLowerCase().replaceAll(' ', '-') + ']'*/ /*** ADD this for lower version of addon plugin ****/
  }

  _getSelectKey(List<ProductAddonsModel> productAddons, int i, int f) {
    return 'addon-' + widget.product.id.toString() + '-' + productAddons[i].fields[f].name.toLowerCase().replaceAll(' ', '-') + '-' + f.toString();
  }

  _getRadioKey(List<ProductAddonsModel> productAddons, int i, int f) {
    return 'addon-' + widget.product.id.toString() + '-' + productAddons[i].fields[f].name.toLowerCase().replaceAll(' ', '-') + '-' + f.toString(); //+ '[]'
  }

  _getCheckBoxKey(List<ProductAddonsModel> productAddons, int i, int f, int o) {
    return 'addon-' + widget.product.id.toString() + '-' + productAddons[i].fields[f].name.toLowerCase().replaceAll(' ', '-') + '-' + f.toString(); // + '[' + o.toString() + ']'
  }

  _getCheckBoxSelectKey(List<ProductAddonsModel> productAddons, int i, int f, int o) {
    return 'addon-' + widget.product.id.toString() + '-' + productAddons[i].fields[f].name.toLowerCase().replaceAll(' ', '-') + '-' + f.toString() + '[' + o.toString() + ']';
  }

  //Product Addon Level Keys

  _getProductKey(AddonField addOnsField, int f, int o) {
    return 'addon-' + widget.product.id.toString() + '-' + addOnsField.name.toLowerCase().replaceAll(' ', '-') + '-' + f.toString(); // + '[' + addOnsField.options[o].label.toLowerCase().replaceAll(' ', '-') + ']'
  }

  _getProductSelectKey(AddonField addOnsField, int f) {
    return 'addon-' + widget.product.id.toString() + '-' + addOnsField.name.toLowerCase().replaceAll(' ', '-') + '-' + f.toString();
  }

  _getProductRadioKey(AddonField addOnsField, int f) {
    return 'addon-' + widget.product.id.toString() + '-' + addOnsField.name.toLowerCase().replaceAll(' ', '-') + '-' + f.toString() + '[]';
  }

  _getProductCheckBoxKey(AddonField addOnsField, int f, int o) {
    return 'addon-' + widget.product.id.toString() + '-' + addOnsField.name.toLowerCase().replaceAll(' ', '-') + '-' + f.toString() + '[' + o.toString() + ']';
  }

  _getProductCheckBoxSelectKey(AddonField addOnsField, int f, int o) {
    return 'addon-' + widget.product.id.toString() + '-' + addOnsField.name.toLowerCase().replaceAll(' ', '-') + '-' + f.toString();
  }

  String _getPrice(AddonOption option) {
    if(option.price != null && option.price.isNotEmpty) {
      return formatter.format(double.parse(option.price)).toString();
    } else {
      return '';
    }
  }

}
