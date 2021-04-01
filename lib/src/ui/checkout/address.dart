import 'package:flutter/material.dart';
import 'package:place_picker/entities/entities.dart';
import 'place_picker.dart';

import '../../blocs/checkout_bloc.dart';
import '../../config.dart';
import '../../functions.dart';
import '../../models/app_state_model.dart';
import '../../models/checkout/checkout_form_model.dart' hide Country;
import '../color_override.dart';
import 'checkout_one_page.dart';

class Address extends StatefulWidget {
  final CheckoutBloc homeBloc;
  final appStateModel = AppStateModel();
  Address({Key key, this.homeBloc}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {

  List<Region> regions;
  TextEditingController _billingAddress1Controller = TextEditingController();
  TextEditingController _billingCityController = TextEditingController();
  TextEditingController _billingPostCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Config config = Config();

  @override
  void initState() {
    super.initState();
    widget.homeBloc.getCheckoutForm();
    widget.homeBloc.updateOrderReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appStateModel.blocks.localeText.address),
      ),
      body: StreamBuilder<CheckoutFormModel>(
          stream: widget.homeBloc.checkoutForm,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? buildCheckoutForm(context, snapshot)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }

  buildCheckoutForm(BuildContext context, AsyncSnapshot<CheckoutFormModel> snapshot) {

    if(snapshot.data.countries.length > 0) {
      if(snapshot.data.countries.length == 1) {
        regions = snapshot.data.countries[0].regions;
        snapshot.data.billingCountry = snapshot.data.countries.first.value;
        widget.homeBloc.formData['billing_country'] = snapshot.data.countries.first.value;
      }
      else if(snapshot.data.countries.indexWhere((country) => country.value == snapshot.data.billingCountry) != -1) {
        regions = snapshot.data.countries.singleWhere((country) => country.value == snapshot.data.billingCountry).regions;
      } else if(snapshot.data.countries.indexWhere((country) => country.value == snapshot.data.billingCountry) == -1) {
        snapshot.data.billingCountry = snapshot.data.countries.first.value;
      }
    }

    if(regions != null && regions.length != 0) {
      snapshot.data.billingState = regions.any((z) => z.value == snapshot.data.billingState) ? snapshot.data.billingState
          : regions.first.value;
      widget.homeBloc.formData['billing_state'] = snapshot.data.billingState;
    }

    if(_billingAddress1Controller.text.isEmpty)
    _billingAddress1Controller.text = snapshot.data.billingAddress1;
    if(_billingCityController.text.isEmpty)
    _billingCityController.text = snapshot.data.billingCity;
    if(_billingPostCodeController.text.isEmpty)
    _billingPostCodeController.text = snapshot.data.billingPostcode;

    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                FlatButton(
                  colorBrightness: Theme.of(context).brightness,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      Icon(Icons.add_location),
                      Text(widget.appStateModel.blocks.localeText.selectLocation)
                    ], ),
                  onPressed: () {
                    showPlacePicker(snapshot);
                  },
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    initialValue: snapshot.data.billingFirstName,
                    decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.firstName),
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.appStateModel.blocks.localeText.pleaseEnterFirstName;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.homeBloc.formData['billing_first_name'] = value;
                    },
                  ),
                ),
                SizedBox(height: 12.0),
                PrimaryColorOverride(
                  child: TextFormField(
                    initialValue: snapshot.data.billingLastName,
                    decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.lastName),
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.appStateModel.blocks.localeText.pleaseEnterLastName;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.homeBloc.formData['billing_last_name'] = value;
                    },
                  ),
                ),
                SizedBox(height: 12.0),
                PrimaryColorOverride(
                  child: TextFormField(
                    controller: _billingAddress1Controller,
                    decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.address),
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.appStateModel.blocks.localeText.pleaseEnterAddress;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.homeBloc.formData['billing_address_1'] = value;
                    },
                  ),
                ),
                SizedBox(height: 12.0),
                PrimaryColorOverride(
                  child: TextFormField(
                    initialValue: snapshot.data.billingAddress2,
                    decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.address + ' 2'),
                    onSaved: (value) {
                      widget.homeBloc.formData['billing_address_2'] = value;
                    },
                  ),
                ),
                SizedBox(height: 12.0),
                PrimaryColorOverride(
                  child: TextFormField(
                    controller: _billingCityController,
                    decoration: InputDecoration(
                      labelText: widget.appStateModel.blocks.localeText.city,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.appStateModel.blocks.localeText.pleaseEnterCity;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.homeBloc.formData['billing_city'] = value;
                    },
                  ),
                ),
                SizedBox(height: 12.0),
                PrimaryColorOverride(
                  child: TextFormField(
                    controller: _billingPostCodeController,
                    decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.pincode),
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.appStateModel.blocks.localeText.pleaseEnterPincode;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.homeBloc.formData['billing_postcode'] = value;
                    },
                  ),
                ),
                SizedBox(height: 12.0),
                PrimaryColorOverride(
                  child: TextFormField(
                    initialValue: snapshot.data.billingEmail,
                    decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.email),
                    onSaved: (value) {
                      widget.homeBloc.formData['billing_email'] = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 12.0),
                PrimaryColorOverride(
                  child: TextFormField(
                    initialValue: snapshot.data.billingPhone,
                    decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.phoneNumber),
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.appStateModel.blocks.localeText.pleaseEnterPhoneNumber;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.homeBloc.formData['billing_phone'] = value;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(height: 10,),
                snapshot.data.countries.length > 1 ? Column(
                  children: [
                    SizedBox(height: 10,),
                    DropdownButton<String>(
                      value: snapshot.data.billingCountry,
                      hint: Text(widget.appStateModel.blocks.localeText.country),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).dividerColor,
                      ),
                      onChanged: (String newValue) {
                        widget.homeBloc.formData['billing_state'] = '';
                        widget.homeBloc.formData['shipping_state'] = '';
                        setState(() {
                          snapshot.data.billingCountry = newValue;
                        });
                        widget.homeBloc.formData['billing_country'] = snapshot.data.billingCountry;
                        //*** Remove When Shipping ADDRESS is different ***//
                        widget.homeBloc.formData['shipping_country'] = snapshot.data.billingCountry;
                        widget.homeBloc.updateOrderReview2();
                      },
                      items: snapshot.data.countries
                          .map<DropdownMenuItem<String>>(
                              (value) {
                            return DropdownMenuItem<String>(
                              value: value.value != null ? value.value : '',
                              child: Text(parseHtmlString(value.label)),
                            );
                          }).toList(),
                    ),
                  ],
                ) : Container(),
                (regions != null  && regions.length != 0) ? Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    DropdownButton<String>(
                      value: snapshot.data.billingState,
                      hint: Text(widget.appStateModel.blocks.localeText.state),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).dividerColor,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          snapshot.data.billingState = newValue;
                        });
                        widget.homeBloc.formData['billing_state'] = snapshot.data.billingState;
                        //*** Remove When Shipping ADDRESS is different ***//
                        widget.homeBloc.formData['shipping_state'] = snapshot.data.billingState;
                        widget.homeBloc.updateOrderReview2();
                      },
                      items: regions
                          .map<DropdownMenuItem<String>>(
                              (value) {
                            return DropdownMenuItem<String>(
                              value: value.value != null ? value.value : '',
                              child: Text(parseHtmlString(value.label)),
                            );
                          }).toList(),
                    ),
                  ],
                ) : PrimaryColorOverride(
                  child: TextFormField(
                    initialValue: widget.homeBloc.formData['billing_state'],
                    decoration: InputDecoration(labelText: widget.appStateModel.blocks.localeText.state),
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.appStateModel.blocks.localeText.pleaseEnterState;
                      }
                    },
                    onSaved: (val) => setState(() => widget.homeBloc.formData['billing_state'] = val),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                child: Text(widget.appStateModel.blocks.localeText.localeTextContinue),
                onPressed: () {
                  widget.homeBloc.formData['security'] = snapshot.data.nonce.updateOrderReviewNonce;
                  widget.homeBloc.formData['woocommerce-process-checkout-nonce'] = snapshot.data.wpnonce;
                  widget.homeBloc.formData['wc-ajax'] = 'update_order_review';

                  widget.homeBloc.formData['billing_country'] = snapshot.data.billingCountry;

                  //*** Remove When Shipping ADDRESS is different ***//
                  widget.homeBloc.formData['shipping_country'] = snapshot.data.billingCountry;
                  widget.homeBloc.formData['shipping_postcode'] = widget.homeBloc.formData['billing_postcode'];


                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.homeBloc.updateOrderReview2();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckoutOnePage(
                              homeBloc: widget.homeBloc,
                            )));
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showPlacePicker(AsyncSnapshot<CheckoutFormModel> snapshot) async {
    LocationResult result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlacePicker(config.mapApiKey)));
    if(result != null) {
      setState(() {
        _billingAddress1Controller.text = result.formattedAddress;
        _billingCityController.text = result.city.name;
        _billingPostCodeController.text = result.postalCode;
      });
      if(snapshot.data.countries.indexWhere((country) => country.value == result.country.shortName) != -1) {
        setState(() {
          snapshot.data.billingCountry = result.country.shortName;
        });
        regions = snapshot.data.countries.singleWhere((country) => country.value == result.country.shortName).regions;
      } else if(snapshot.data.countries.length != 0) {
        snapshot.data.billingCountry = snapshot.data.countries.first.value;
      } if(regions != null) {
        snapshot.data.billingState = regions.any((z) => z.value == result.administrativeAreaLevel1.shortName) ? result.administrativeAreaLevel1.shortName
            : regions.first.value;
      }
    }
  }
}

