import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:path/path.dart' as p;
//import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';

import 'others/splash.dart';
import 'src/app.dart';
import 'src/data/gallery_options.dart';
import 'src/models/app_state_model.dart';
import 'src/resources/api_provider.dart';
import 'src/themes/gallery_theme_data_material.dart';
import 'src/ui/intro/intro_slider.dart';

//Directory _appDocsDir;

void setOverrideForDesktop() {
  if (kIsWeb) return;

  if (Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  } else if (Platform.isFuchsia) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() async {
  setOverrideForDesktop();
  AppStateModel model = AppStateModel();
  WidgetsFlutterBinding.ensureInitialized();
  await model.getLocalData();
  //UnComment when SSL site not working
  //HttpOverrides.global = new MyHttpOverrides();
  //SharedPreferences.setMockInitialValues({});
  //UnComment when Using Dynamic Splash
  //_appDocsDir = await getApplicationDocumentsDirectory();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final AppStateModel model = AppStateModel();
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final apiProvider = ApiProvider();
  Timer _timer;
  int _start = 0;
  var splashIndex = ['0', '1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    apiProviderInt();
    //splashIndex.shuffle();
    //startTimer();
  }

  File fileFromDocsDir(String filename) {
    //TODO Uncomment when using dynamic splash
    //String pathName = p.join(_appDocsDir.path, filename);
    //return File(pathName);
  }

  void apiProviderInt() async {
    await apiProvider.init();
    widget.model.fetchAllBlocks();
    widget.model.getCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.system,
        customTextDirection: CustomTextDirection.localeBased,
        textScaleFactor: 1,
        locale: widget.model.appLocale,
        platform: defaultTargetPlatform,
      ),
      child: Builder(
        builder: (context) {
          //print(GalleryOptions.of(context).locale.languageCode);
          return ScopedModel<AppStateModel>(
              model: widget.model,
              child: MaterialApp(
                  localizationsDelegates: [
                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: GalleryOptions.supportedLocales,
                  locale: GalleryOptions.of(context).locale,
                  title: 'WooCommerce',
                  debugShowCheckedModeBanner: false,
                  themeMode: GalleryOptions.of(context).themeMode,
                  theme: GalleryOptions.of(context).locale == Locale('ar')
                      ? GalleryThemeData.lightArabicThemeData.copyWith(
                          platform: GalleryOptions.of(context).platform,
                        )
                      : GalleryThemeData.lightThemeData.copyWith(
                          platform: GalleryOptions.of(context).platform,
                        ),
                  darkTheme: GalleryOptions.of(context).locale == Locale('ar')
                      ? GalleryThemeData.darkArabicThemeData.copyWith(
                          platform: GalleryOptions.of(context).platform,
                        )
                      : GalleryThemeData.darkThemeData.copyWith(
                          platform: GalleryOptions.of(context).platform,
                        ),
                  home: ScopedModelDescendant<AppStateModel>(
                      builder: (context, child, model) {
                    if (model.hasSeenIntro == null) {
                      return IntroScreen();
                    } else if (model.blocks != null && _start == 0) {
                      return App(); /*ShrineApp()*/
                    } else {
                      return Material(
                          child: Scaffold(
                            body: AnnotatedRegion<SystemUiOverlayStyle>(
                              value: SystemUiOverlayStyle.dark,
                              child: Center(
                                child: Container(
                                    width: 200,
                                    child: Image.asset('lib/assets/images/logo.png', fit: BoxFit.fitHeight,)
                                ),
                              ),
                            ),
                          )
                      );

                      //For dinamic splash not used because issues in pathprovider in recent flutter update
                      return Material(
                        child: Stack(
                          children: [
                            Container(
                                height: MediaQuery.of(context).size.height,
                                child: Image(
                                    fit: BoxFit.fitHeight,
                                    image: NetworkToFileImage(
                                        url: '',
                                        file: fileFromDocsDir(
                                            "splash" + splashIndex[0] + ".jpg"),
                                        debug: true))),
                            model.blocks != null
                                ? Positioned(
                                    top: 20,
                                    right: 20,
                                    child: FlatButton(
                                      child: Text('SKIP 0' + _start.toString()),
                                      onPressed: () => cancelTimer(),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      );
                    }
                  })));
        },
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            cancelTimer();
          } else {
            _start = _start - 1;
          }
          print(_start);
        },
      ),
    );
  }

  void cancelTimer() {
    _timer.cancel();
    setState(() {
      _start = 0;
    });
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

const List<Locale> supportedLocales = <Locale>[
  Locale('en'),
  Locale('af'),
  Locale('am'),
  Locale('ar'),
  Locale('ar', 'EG'),
  Locale('ar', 'JO'),
  Locale('ar', 'MA'),
  Locale('ar', 'SA'),
  Locale('as'),
  Locale('az'),
  Locale('be'),
  Locale('bg'),
  Locale('bn'),
  Locale('bs'),
  Locale('ca'),
  Locale('cs'),
  Locale('da'),
  Locale('de'),
  Locale('de', 'AT'),
  Locale('de', 'CH'),
  Locale('el'),
  Locale('en', 'AU'),
  Locale('en', 'CA'),
  Locale('en', 'GB'),
  Locale('en', 'IE'),
  Locale('en', 'IN'),
  Locale('en', 'NZ'),
  Locale('en', 'SG'),
  Locale('en', 'ZA'),
  Locale('es'),
  Locale('es', '419'),
  Locale('es', 'AR'),
  Locale('es', 'BO'),
  Locale('es', 'CL'),
  Locale('es', 'CO'),
  Locale('es', 'CR'),
  Locale('es', 'DO'),
  Locale('es', 'EC'),
  Locale('es', 'GT'),
  Locale('es', 'HN'),
  Locale('es', 'MX'),
  Locale('es', 'NI'),
  Locale('es', 'PA'),
  Locale('es', 'PE'),
  Locale('es', 'PR'),
  Locale('es', 'PY'),
  Locale('es', 'SV'),
  Locale('es', 'US'),
  Locale('es', 'UY'),
  Locale('es', 'VE'),
  Locale('et'),
  Locale('eu'),
  Locale('fa'),
  Locale('fi'),
  Locale('fil'),
  Locale('fr'),
  Locale('fr', 'CA'),
  Locale('fr', 'CH'),
  Locale('gl'),
  Locale('gsw'),
  Locale('gu'),
  Locale('he'),
  Locale('hi'),
  Locale('hr'),
  Locale('hu'),
  Locale('hy'),
  Locale('id'),
  Locale('is'),
  Locale('it'),
  Locale('ja'),
  Locale('ka'),
  Locale('kk'),
  Locale('km'),
  Locale('kn'),
  Locale('ko'),
  Locale('ky'),
  Locale('lo'),
  Locale('lt'),
  Locale('lv'),
  Locale('mk'),
  Locale('ml'),
  Locale('mn'),
  Locale('mr'),
  Locale('ms'),
  Locale('my'),
  Locale('nb'),
  Locale('ne'),
  Locale('nl'),
  Locale('or'),
  Locale('pa'),
  Locale('pl'),
  Locale('pt'),
  Locale('pt', 'BR'),
  Locale('pt', 'PT'),
  Locale('ro'),
  Locale('ru'),
  Locale('si'),
  Locale('sk'),
  Locale('sl'),
  Locale('sq'),
  Locale('sr'),
  Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn'),
  Locale('sv'),
  Locale('sw'),
  Locale('ta'),
  Locale('te'),
  Locale('th'),
  Locale('tl'),
  Locale('tr'),
  Locale('uk'),
  Locale('ur'),
  Locale('uz'),
  Locale('vi'),
  Locale('zh'),
  Locale('zh', 'CN'),
  Locale('zh', 'HK'),
  Locale('zh', 'TW'),
  Locale('zu')
];
