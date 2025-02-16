import 'package:flexx_bet/models/models.dart';

class Globals {
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiZmxleHgyMiIsImEiOiJjbGlkMDdzazcwMXd6M2tsc3V3NHVteG1pIn0.-Vh1AooAzEj70JMIWQ-GPA';

  static const String flutterWaveSecretKey =
      'FLWSECK_TEST-5d3899451be04ac0da869115424ca6cd-X';
  static const String flutterWavePublicKey =
      "FLWPUBK_TEST-a58491b8f95ff1337cc513cc70c1db59-X";

  static const String mapBoxStyleId = 'cjikt35x83t1z2rnxpdmjs7y7';

  static const String defaultLanguage = 'en';
//List of languages that are supported.  Used in selector.
//Follow this plugin for translating a google sheet to languages
//https://github.com/aloisdeniel/flutter_sheet_localization
//Flutter App translations google sheet
//https://docs.google.com/spreadsheets/d/1oS7iJ6ocrZBA53SxRfKF0CG9HAaXeKtzvsTBhgG4Zzk/edit?usp=sharing

  static final List<MenuOptionsModel> languageOptions = [
    //English
    MenuOptionsModel(key: "en", value: "English"), //English
  ];
}
