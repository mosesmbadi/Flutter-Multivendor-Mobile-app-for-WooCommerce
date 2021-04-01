import 'package:flutter/material.dart';

import './../../../blocs/customer_bloc.dart';
import './../../../models/app_state_model.dart';
import './../../../models/customer_model.dart';
import 'edit_address.dart';


class CustomerAddress extends StatefulWidget {

  final appStateModel = AppStateModel();

  CustomerBloc customerBloc = CustomerBloc();
  CustomerAddress({Key key}) : super(key: key);
  @override
  _CustomerAddressState createState() => _CustomerAddressState();
}

class _CustomerAddressState extends State<CustomerAddress> {
  @override
  void initState() {
    super.initState();
    widget.customerBloc.getCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: Text(widget.appStateModel.blocks.localeText.address),
      ),
      body: StreamBuilder(
          stream: widget.customerBloc.customerDetail,
          builder: (context, AsyncSnapshot<Customer> snapshot) {
            if (snapshot.hasData) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget buildList(AsyncSnapshot<Customer> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(

        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditAddress(customerBloc: widget.customerBloc, customer: snapshot)));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              //title: Text(widget.appStateModel.blocks.localeText.address, style: Theme.of(context).textTheme.subtitle),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '''${snapshot.data.billing.firstName} ${snapshot.data.billing.lastName} ${snapshot.data.billing.address1} ${snapshot.data.billing.address2} ${snapshot.data.billing.city} ${snapshot.data.billing.state} ${snapshot.data.billing.postcode} ${snapshot.data.billing.country} ${snapshot.data.billing.email} ${snapshot.data.billing.phone}
                        '''),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
