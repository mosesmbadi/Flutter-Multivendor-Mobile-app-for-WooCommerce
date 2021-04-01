import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../blocs/order_summary_bloc.dart';


class PaytmPage extends StatefulWidget {
  final String id;
  final OrderSummaryBloc orderSummary = OrderSummaryBloc();

 PaytmPage({Key key, this.id}) : super(key: key);
  @override
  _PaytmPageState createState() => _PaytmPageState();
}

class _PaytmPageState extends State<PaytmPage> {
  String payment_response;
  //Paytm _paytm;



  String get callBackUrl => 'https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=';


  @override
  void initState(){
    super.initState();
    //widget.orderSummary.getOrder(widget.id);
   // _paytm =Paytm();

  }


  void checkout(String url) async {

    final response = await http.post('https://us-central1-mrdishant-4819c.cloudfunctions.net/generateCheckSum', headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
        body: {
          "mid": "ParloS79006455919746",
          "CHANNEL_ID": "WAP",
          'INDUSTRY_TYPE_ID': 'Retail',
          'WEBSITE': 'APPSTAGING',
          'PAYTM_MERCHANT_KEY': '380W#7mf&_SpEgsy',
          'TXN_AMOUNT': '10',
          'ORDER_ID': widget.id,
          'CUST_ID': '122',
        });
    var checksum = response.body;


    /*var paytmResponse  = Paytm.startPaytmPayment(
        true,
        "ParloS79006455919746",
        widget.id,
        "122",
        "WAP",
        "10",
        'APPSTAGING',
        callBackUrl,
        'Retail',
        response.body);*/
  

  /* paytmResponse.then((value) {
      setState(() {
        payment_response = value.toString();
      });
    });*/
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paytm'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: 120.0,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Please enter amount"),
                onChanged: (value) {
                  setState(() {
                  });
                },
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            RaisedButton(
              child: Text('Make Payment'),
              onPressed: () {

                checkout(callBackUrl);
              },
            )
          ],
        ),
      ),
    );
  }
}
