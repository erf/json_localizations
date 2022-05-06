import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A class that reads JSON-based localization files.
class JsonLocalizations {
  /// Translations per language tag.
  final Map<String, dynamic> translations = {};

  /// Path to the translation file.
  final String assetPath;

  /// The asset bundle.
  final AssetBundle assetBundle;

  /// A language tag for the current locale.
  late String langTag;

  /// Initialize with asset path to JSON files and an optional assetBundle.
  JsonLocalizations(this.assetPath, [assetBundle])
      : assetBundle = assetBundle ?? rootBundle;

  /// Load a JSON file from the asset bundle and parse it into a map.
  Future<Map<String, dynamic>> loadFile(Locale locale) async {
    try {
      final text = await assetBundle.loadString('$assetPath/$langTag.json');
      return json.decode(text);
    } catch (e) {
      debugPrint(e.toString());
    }
    // load only language code
    if (langTag != locale.languageCode) {
      langTag = locale.languageCode;
      try {
        final text = await assetBundle.loadString('$assetPath/$langTag.json');
        return json.decode(text);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    // return empty map
    return {};
  }

  /// Load and cache a JSON file given a locale.
  Future<JsonLocalizations> load(Locale locale) async {
    langTag = locale.toLanguageTag();
    // in cache already
    if (translations.containsKey(langTag)) {
      return this;
    }
    // load combined key of languageCode and countryCode
    translations[langTag] = await loadFile(locale);
    return this;
  }

  /// Get translation given a key.
  dynamic value(String key) => translations[langTag]![key];

  /// Helper for getting [JsonLocalizations] object.
  static JsonLocalizations? of(BuildContext context) =>
      Localizations.of<JsonLocalizations>(context, JsonLocalizations);
}

/// [JsonLocalizationsDelegate] add this to `MaterialApp.localizationsDelegates`
class JsonLocalizationsDelegate
    extends LocalizationsDelegate<JsonLocalizations> {
  final JsonLocalizations localization;

  JsonLocalizationsDelegate(String path, [AssetBundle? assetBundle])
      : localization = JsonLocalizations(path, assetBundle);

  /// We expect all supportedLocales to have asset files.
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<JsonLocalizations> load(Locale locale) {
    return localization.load(locale);
  }

  @override
  bool shouldReload(JsonLocalizationsDelegate old) => false;
}
