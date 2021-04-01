import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../src/models/app_state_model.dart';
import '../../models/blocks_model.dart';

class CurrencyPage extends StatefulWidget {
  CurrencyPage({Key key}) : super(key: key);
  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {

  String _selectedCurrency;
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
    _selectedCurrency = appStateModel.selectedCurrency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          title: Text(appStateModel.blocks.localeText.currency)
      ),
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            if (model.blocks?.currencies != null) {
              return buildCurrencyItems(model.blocks.currencies);
            } else
              return Container();
          }));
  }

  Widget buildCurrencyItems(List<Currency> currency) {
    return ListView.builder
      (
        itemCount: currency.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
               return Column(
                children: <Widget>[
                  ListTile(
                    trailing: Radio<String>(
                      value: currency[index].code,
                      groupValue: _selectedCurrency,
                      onChanged: (value) async {
                        setState(() {
                          _selectedCurrency = currency[index].code;
                        });
                        model.selectedCurrency = currency[index].code;
                        await model.switchCurrency(currency[index].code);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('currency', currency[index].code);
                        model.fetchAllBlocks();
                      },
                    ),
                    title: Text(currency[index].code),
                    onTap: () async {
                      setState(() {
                        _selectedCurrency = currency[index].code;
                      });
                      model.selectedCurrency = currency[index].code;
                      await model.switchCurrency(currency[index].code);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('currency', currency[index].code);
                      model.fetchAllBlocks();
                    },
                  ),
                  Divider(height: 0,)
                ],
              );
            }
          );
        }
    );
  }
}


