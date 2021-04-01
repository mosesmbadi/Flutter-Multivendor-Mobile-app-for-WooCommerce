import 'package:flutter/material.dart';

import '../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../functions.dart';
import '../../../../models/checkout/checkout_form_model.dart';
import '../../../../models/customer_model.dart';
import '../../../../models/orders_model.dart';
import '../../../../ui/color_override.dart';


class AddCustomer extends StatefulWidget {
  final VendorBloc vendorBloc;
final Order order;
   AddCustomer({Key key, this.vendorBloc,this.order}) : super(key: key);

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {

  final _formKey = GlobalKey<FormState>();

  final billing = Address();
  final shipping = Address();
  List<Region> regions;



  @override
  void initState() {
    super.initState();
    widget.vendorBloc.getVendorOrderForm();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Customer'),
      ),

      body: StreamBuilder<CheckoutFormModel>(
          stream: widget.vendorBloc.vendorOrderForm,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? buildListView(context, snapshot)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }


  Widget buildListView(BuildContext context, AsyncSnapshot<CheckoutFormModel> snapshot) {
    if (snapshot.data.countries.indexWhere((country) =>
    country.value == widget.order.billing.country) != -1) {
      regions = snapshot.data.countries
          .singleWhere((country) =>
      country.value == widget.order.billing.country)
          .regions;
    } else if (snapshot.data.countries.indexWhere((country) => country.value ==
        widget.order.billing.country) == -1) {
      widget.order.billing.country = snapshot.data.countries.first.value;
    }
    if (regions != null && regions.isNotEmpty) {
      widget.order.billing.state =
      regions.any((z) => z.value == widget.order.billing.state) ? widget.order
          .billing.state
          : regions.first.value;
    }

    return
      SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Billing Details",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  TextFormField(
                    initialValue: widget.order.billing.firstName,
                    decoration: InputDecoration(
                      labelText:
                      "FirstName",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "please enter firstname";
                      }
                    },
                    onSaved: (val) => setState(() => widget.order.billing.firstName = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText:
                        "LastName"
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "please enter last name";
                      }
                    },
                    onSaved: (val) => setState(() => widget.order.billing.lastName = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText:
                      "Company",
                    ),

                    onSaved: (val) => setState(() =>  widget.order.billing.company = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText:
                      "Address1",
                    ),

                    onSaved: (val) => setState(() =>  widget.order.billing.address1 = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText:
                      "Address2",
                    ),

                    onSaved: (val) => setState(() =>  widget.order.billing.address2 = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "City",
                    ),

                    onSaved: (val) => setState(() =>  widget.order.billing.city = val),
                  ),


                  TextFormField(
                    decoration: InputDecoration(
                      labelText:
                      "Postcode",
                    ),

                    onSaved: (val) => setState(() =>  widget.order.billing.postcode = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText:
                        "Email"
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter email";
                      }
                    },
                    onSaved: (val) => setState(() =>  widget.order.billing.email = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText:
                        "Phonenumber"
                    ),
                    onSaved: (val) => setState(() =>  widget.order.billing.phone = val),
                  ),


                  SizedBox(
                    height: 20,
                  ),
                 DropdownButton<String>(
                    value: widget.order.billing.country,
                    hint: Text("Country"),
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
                        widget.order.billing.country = newValue;
                      });
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
                  (regions != null  && regions.length != 0) ? Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      DropdownButton<String>(
                        value: widget.order.billing.state,
                        hint: Text('state'),
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
                            widget.order.billing.state =
                                newValue;
                          });
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
                      initialValue: widget.order.billing.state,
                      decoration: InputDecoration(labelText: 'State'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter State";
                        }
                      },
                      onSaved: (val) => setState(() => widget.vendorBloc.formData['billing_state'] = val),
                    ),
                  ),


                  SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    "Shipping Details:",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText:
                        "FirstName"
                    ),

                    onSaved: (val) => setState(() =>  widget.order.shipping.firstName = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText:
                        "LastName"
                    ),

                    onSaved: (val) => setState(() =>  widget.order.shipping.lastName = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText:
                        "Company"
                    ),

                    onSaved: (val) => setState(() =>  widget.order.shipping.company = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText:
                        "Address1"
                    ),

                    onSaved: (val) => setState(() => widget.order.shipping.address1 = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText:
                        "Address2"
                    ),

                    onSaved: (val) => setState(() =>  widget.order.shipping.address2 = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "City"
                    ),

                    onSaved: (val) => setState(() => widget.order.shipping.city = val),
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                        labelText:
                        "Postcode"
                    ),

                    onSaved: (val) => setState(() => widget.order.shipping.postcode = val),
                  ),


                  SizedBox(
                    height: 20,
                  ),

              DropdownButton<String>(
                    value: widget.order.shipping.country,
                    hint: Text("Country"),
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
                        widget.order.shipping.country = newValue;
                      });
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
                  (regions != null  && regions.length != 0) ? Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      DropdownButton<String>(
                        value: widget.order.shipping.state,
                        hint: Text('state'),
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
                            widget.order.shipping.state =
                                newValue;
                          });
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
                      initialValue: widget.order.shipping.state,
                      decoration: InputDecoration(labelText: 'State'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter State";
                        }
                      },
                      onSaved: (val) => setState(() => widget.vendorBloc.formData['billing_state'] = val),
                    ),
                  ),






                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: RaisedButton(
                        onPressed: () {
                          print(widget.order);
                          //_formKey.currentState.validate()
                          if (true) {
                            _formKey.currentState.save();
                            //widget.order.billing = billing;
                            //widget.order.shipping = shipping;
                           // shipping.country = '';

                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                            "Done",
                            textAlign: TextAlign.center),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
  }

}
