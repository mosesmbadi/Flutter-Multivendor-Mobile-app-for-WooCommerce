class Config {
  /* Replace your sire url and api keys */

  String url = 'http://example.com';
  String consumerKey = 'ck_b237d93be5900119fGhstjd835dd0d280902b';
  String consumerSecret = 'cs_69c5275a9ce507Hstjus2548b2b95f9795a814';

  //Android MAP API Key
  //String mapApiKey = 'AIzaSyC1BxltYbbVoNashjudkIBYeLjjMk4whkU7jw';

  //iOS MAP API Key
  String mapApiKey = 'AIzaSyC2V9VH3SjGRNshjuabkkAiWUeHt1Yc';

  static Config _singleton = new Config._internal();

  factory Config() {
    return _singleton;
  }

  Config._internal();

  Map<String, dynamic> appConfig = Map<String, dynamic>();

  Config loadFromMap(Map<String, dynamic> map) {
    appConfig.addAll(map);
    return _singleton;
  }

  dynamic get(String key) => appConfig[key];

  bool getBool(String key) => appConfig[key];

  int getInt(String key) => appConfig[key];

  double getDouble(String key) => appConfig[key];

  String getString(String key) => appConfig[key];

  void clear() => appConfig.clear();

  @Deprecated("use updateValue instead")
  void setValue(key, value) => value.runtimeType != appConfig[key].runtimeType
      ? throw ("wrong type")
      : appConfig.update(key, (dynamic) => value);

  void updateValue(String key, dynamic value) {
    if (appConfig[key] != null &&
        value.runtimeType != appConfig[key].runtimeType) {
      throw ("The persistent type of ${appConfig[key].runtimeType} does not match the given type ${value.runtimeType}");
    }
    appConfig.update(key, (dynamic) => value);
  }

  void addValue(String key, dynamic value) =>
      appConfig.putIfAbsent(key, () => value);

  add(Map<String, dynamic> map) => appConfig.addAll(map);
}
