import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Store translations per languageCode/country from a JSON object used by [JsonLocalizationsDelegate].
class JsonLocalizations {
  /// Map of translations per language/country code hash.
  final Map<String, dynamic> _translations = {};

  /// Path to translation assets.
  final String assetPath;

  /// The asset bundle.
  final AssetBundle assetBundle;

  /// A hash key of language / country code used for [_translationsMap].
  late String _codeKey;

  /// Initialize with asset path to JSON files and an optional assetBundle.
  JsonLocalizations(this.assetPath, [assetBundle])
      : assetBundle = assetBundle ?? rootBundle;

  /// Load and cache a JSON file per language / country code.
  Future<JsonLocalizations> load(Locale locale) async {
    // get the key from a combination of languageCode and countryCode
    _codeKey = locale.toLanguageTag();

    // in cache already
    if (_translations.containsKey(_codeKey)) {
      return this;
    }

    // load combined key of languageCode and countryCode
    try {
      final text = await assetBundle.loadString('$assetPath/$_codeKey.json');
      _translations[_codeKey] = json.decode(text);
      return this;
    } catch (e) {
      debugPrint(e.toString());
    }

    // load only language code
    if (_codeKey != locale.languageCode) {
      _codeKey = locale.languageCode;
      try {
        final text = await assetBundle.loadString('$assetPath/$_codeKey.json');
        _translations[_codeKey] = json.decode(text);
        return this;
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    assert(false, 'Translation file not found for code \'$_codeKey\'');

    return this;
  }

  /// Get translation given a key.
  dynamic value(String key) => _translations[_codeKey]![key];

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
