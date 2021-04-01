import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../src/models/app_state_model.dart';
import '../../../src/models/delas_state_model.dart';
import '../../../src/resources/api_provider.dart';
import '../widgets/buttons/button_text.dart';
import '../../config.dart';
import '../color_override.dart';

class TryDemo extends StatefulWidget {
  TryDemo({Key key}) : super(key: key);

  @override
  _TryDemoState createState() => _TryDemoState();
}

class _TryDemoState extends State<TryDemo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController urlController = new TextEditingController();
  final apiProvider = ApiProvider();
  Config config = Config();
  bool isLoading = false;
  String error = '';
  AppStateModel appStateModel = AppStateModel();
  DealsStateModel dealsStateModel = DealsStateModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Demo'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PrimaryColorOverride(
                  child: TextFormField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: 'http://example.com',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Site url';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 22.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      child: ButtonText(isLoading: isLoading, text: appStateModel.blocks.localeText.localeTextContinue),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                            error = '';
                          });
                          final response = await http.get(
                            Uri.parse(urlController.text +
                                '/wp-admin/admin-ajax.php?action=mstore_flutter-keys'),
                          );
                          if (response.statusCode == 200) {
                            config.url = stripSlash(urlController.text);
                            await appStateModel.fetchAllBlocks();
                            appStateModel.getCustomerDetails();
                            dealsStateModel.refresh();
                            Navigator.of(context).pop();
                          } else if (response.statusCode == 400) {
                            setState(() {
                              error = 'Please install plugin and activate';
                            });
                          } else {
                            setState(() {
                              error = 'Please check url';
                            });
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Note - Before contine please read document clearly, install plugin and save settings',
                    style:
                    TextStyle(color: Theme.of(context).accentColor)),
                SizedBox(height: 6.0),
                InkWell(
                    child: new Text('https://mstoreapp.com/documents/flutter/woocommerce/woocommerce/wordpress_plugin_installtion.html', style: TextStyle(
                      color: Colors.blue
                    ),),
                    onTap: () => launch('https://mstoreapp.com/documents/flutter/woocommerce/woocommerce/wordpress_plugin_installtion.html')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

   String stripSlash(String str) {
    if (str != null && str.length > 0 && str.substring(str.length - 1) == '/') {
      str = str.substring(0, str.length - 1);
    }
    return str;
  }
}
