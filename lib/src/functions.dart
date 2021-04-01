import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import 'models/blocks_model.dart';

String parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}

showSnackBarError(BuildContext context, String message) {
  //Fluttertoast.showToast(msg: message, gravity: ToastGravity.TOP);
  final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ));
  Scaffold.of(context).showSnackBar(snackBar);
}

String getOrderIdFromUrl(String str) {
  String orderId = '0';
  if (str.contains('/order-received/') && str.contains('/?key=wc_order')) {
    int pos1 = str.lastIndexOf("/order-received/");
    int pos2 = str.lastIndexOf("/?key=wc_order");
    orderId = str.substring(pos1 + 16, pos2);
    return orderId;
  } else if (str.contains('/order-pay/') && str.contains('/?key=wc_order')) {
    int pos1 = str.lastIndexOf('/order-pay/');
    int pos2 = str.lastIndexOf('/?key=wc_order');
    orderId = str.substring(pos1 + 11, pos2);
    return orderId;
  }
  if (str.contains('/order-received/') && str.contains('?key=wc_order')) {
    int pos1 = str.lastIndexOf("/order-received/");
    int pos2 = str.lastIndexOf("?key=wc_order");
    orderId = str.substring(pos1 + 16, pos2);
    return orderId;
  } else if (str.contains('/order-pay/') && str.contains('?key=wc_order')) {
    int pos1 = str.lastIndexOf('/order-pay/');
    int pos2 = str.lastIndexOf('?key=wc_order');
    orderId = str.substring(pos1 + 11, pos2);
    return orderId;
  } else if (str.lastIndexOf("/order-pay/") != -1 &&
      str.lastIndexOf("/?key=wc_order") != -1) {
    var pos1 = str.lastIndexOf("/order-pay/");
    var pos2 = str.lastIndexOf("/?key=wc_order");
    orderId = str.substring(pos1 + 11, pos2);
    return orderId;
  } else
    return orderId;
}

String getOrderStatusText(String status, LocaleText localeText) {
  switch (status) {
    case "processing":
      return localeText.processing;
      break;
    case "completed":
      return localeText.completed;
      break;
    case "on-hold":
      return localeText.onHold;
      break;
    case "pending":
      return localeText.pending;
      break;
    case "refunded":
      return localeText.refunded;
      break;
    case "cancelled":
      return localeText.cancelled;
      break;
    case "failed":
      return localeText.failed;
      break;
    default:
      return status.toUpperCase();
  }
}

