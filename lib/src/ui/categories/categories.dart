import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../src/models/app_state_model.dart';
import 'categories1.dart';
import 'categories2.dart';
import 'categories3.dart';
import 'categories4.dart';
import 'categories5.dart';
import 'categories6.dart';
import 'categories7.dart';
import 'categories8.dart';
import 'categories9.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
print(model.blocks.pageLayout.category);
      if (model.blocks.pageLayout.category == 'layout1') {
        return Categories1();
      } else if (model.blocks.pageLayout.category == 'layout2') {
        return Categories2();
      } else if (model.blocks.pageLayout.category == 'layout3') {
        return Categories3();
      } else if (model.blocks.pageLayout.category == 'layout4') {
        return Categories4();
      } else if (model.blocks.pageLayout.category == 'layout5') {
        return Categories5();
      } else if (model.blocks.pageLayout.category == 'layout6') {
        return Categories6();
      } else if (model.blocks.pageLayout.category == 'layout7') {
        return Categories7();
      } else if (model.blocks.pageLayout.category == 'layout8') {
        return Categories8();
      } else if (model.blocks.pageLayout.category == 'layout9') {
        return Categories9();
      } else {
        return Categories1();
      }
    });
  }
}
