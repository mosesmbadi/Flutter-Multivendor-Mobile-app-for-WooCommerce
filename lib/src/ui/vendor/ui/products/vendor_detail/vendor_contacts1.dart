import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../blocs/vendor/vendor_detail_state_model.dart';
import '../../../../../config.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/vendor_details_model.dart';

class VendorContacts1 extends StatefulWidget {
  final VendorDetailStateModel vendorDetailsBloc;
  final Store store;
  const VendorContacts1({Key key, this.vendorDetailsBloc, this.store})
      : super(key: key);
  @override
  _VendorContacts1State createState() => _VendorContacts1State();
}

class _VendorContacts1State extends State<VendorContacts1> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng _lastMapPosition;
  final Set<Marker> _markers = {};
  Config config = Config();
  AppStateModel appStateModel = AppStateModel();

  MapType _currentMapType = MapType.normal;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  BitmapDescriptor pinLocationIcon;
  void initState() {
    super.initState();
    print(widget.store.latitude);
    print(widget.store.longitude);
    _lastMapPosition = LatLng(double.parse(widget.store.latitude),
        double.parse(widget.store.longitude));
    _markers.add(Marker(
      markerId: MarkerId(_lastMapPosition.toString()),
      position: _lastMapPosition,
    ));
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 1.5),
            'lib/assets/images/LocationPin.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  Map contactData = new Map<String, dynamic>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    LatLng pinPosition = LatLng(37.3797536, -122.1017334);
    Color hintColor = Theme.of(context).hintColor;
    return Container(
      padding: const EdgeInsets.fromLTRB(
          16.0, 16.0, 16.0, 20.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            double.parse(widget.store.latitude) != 0
                ? Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Colors.grey.withOpacity(0.4))),
              //color: Colors.teal,
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _lastMapPosition,
                      zoom: 11.0,
                    ),
                    gestureRecognizers: Set()
                      ..add(Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer())),
                    scrollGesturesEnabled: true,
                    onMapCreated: _onMapCreated,
                    mapType: _currentMapType,
                    markers: _markers,
                  ),
                ],
              ),
            )
                : Container(),
            Container(
              //padding:  EdgeInsets.all(8),
              //margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: new Form(
                key: _formKey,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    buildTextFormField(nameController,
                        appStateModel.blocks.localeText.name),
                    SizedBox(height: 16.0),
                    buildTextFormField(emailController,
                        appStateModel.blocks.localeText.email),
                    SizedBox(height: 16.0),
                    buildTextFormField(phoneController,
                        appStateModel.blocks.localeText.phoneNumber),
                    SizedBox(height: 16.0),
                    TextFormField(
                      maxLength: 100,
                      minLines: 5,
                      maxLines: 7,
                      controller: messageController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).focusColor)),
                        border: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).focusColor)),
                        alignLabelWithHint: true,
                        labelText: appStateModel.blocks.localeText.message,
                        errorMaxLines: 1,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return appStateModel
                              .blocks.localeText.pleaseEnter +
                              ' ' +
                              appStateModel.blocks.localeText.message;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      child: Text(appStateModel
                          .blocks.localeText.localeTextContinue),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          contactData["name"] = nameController.text;
                          contactData["email"] = emailController.text;
                          contactData["phone"] = phoneController.text;
                          contactData["message"] = messageController.text;
                          contactData["vendor"] = widget.store.id.toString();
                          widget.vendorDetailsBloc.submitContactForm(contactData);
                          _showThankYouDialogue();
                          contactData = new Map<String, dynamic>();
                          nameController.clear();
                          emailController.clear();
                          phoneController.clear();
                          messageController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ]),
    );
  }

  TextFormField buildTextFormField(
      TextEditingController controller, String name) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).focusColor)),
        border: OutlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).focusColor)),
        labelText: name,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return appStateModel.blocks.localeText.pleaseEnter +
              ' ' +
              '${name.toLowerCase()}';
        }
        return null;
      },
    );
  }

  Container buildIcon(child) {
    return Container(
      width: 30,
      height: 30,
      child: child,
    );
  }

  void _showThankYouDialogue() {
    showDialog(context: context,
        barrierDismissible: false,
        // ignore: deprecated_member_use
        child: AlertDialog(
          title: new Text(appStateModel.blocks.localeText.thankYou),
          content: new Text(appStateModel.blocks.localeText.thankYouForYourMessage),
          actions: <Widget>[
            RaisedButton(
                elevation: 0,
                child: Text(appStateModel.blocks.localeText.localeTextContinue),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            )
          ],
        )
    );
  }
}
