import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../models/app_state_model.dart';
import 'account4.dart';
import 'account7.dart';
import 'account8.dart';
import 'account9.dart';
import 'account10.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (model.blocks.pageLayout.account == 'layout1') {
            return UserAccount7();
          } else if (model.blocks.pageLayout.account == 'layout2') {
            return UserAccount8();
          } else if (model.blocks.pageLayout.account == 'layout3') {
            return UserAccount10();
          } else if (model.blocks.pageLayout.account == 'layout10') {
            return UserAccount10();
          } else if (model.blocks.pageLayout.account == 'layout4') {
            return UserAccount4();
          } else {
            return UserAccount7();
          }
        });
  }
}


