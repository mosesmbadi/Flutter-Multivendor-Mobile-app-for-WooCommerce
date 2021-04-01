import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './../../../models/app_state_model.dart';
import './../../../models/blocks_model.dart';
import './../../../resources/api_provider.dart';
import '../../../data/gallery_options.dart';

class LanguagePage extends StatefulWidget {
  LanguagePage(
      {Key key})
      : super(key: key);
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  final apiProvider = ApiProvider();
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Text(
            appStateModel.blocks.localeText.language,
          ),
        ),
        body: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              if (model.blocks?.languages != null) {
                return buildLanguageItems(model.blocks.languages);
              } else
                return Container();
            }));
  }

  Widget buildLanguageItems(List<Language> languages) {
    final options = GalleryOptions.of(context);
    return ListView.builder(
        itemCount: languages.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Column(
            children: <Widget>[
              new ListTile(
                trailing: Radio<String>(
                  value: languages[index].code,
                  groupValue: apiProvider.filter['lan'],
                  onChanged: (value) async {
                    appStateModel.updateLanguage(languages[index].code);
                    GalleryOptions.update(
                      context,
                      options.copyWith(locale: Locale(languages[index].code),
                    ));
                  },
                ),
                title: Text(languages[index].nativeName),
                onTap: () async {
                  appStateModel.updateLanguage(languages[index].code);
                  GalleryOptions.update(
                    context,
                    options.copyWith(locale: Locale(languages[index].code),
                  ));
                },
              ),
              Divider(
                height: 0,
              )
            ],
          );
        });
  }
}
