import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// store translations per languageCode/country from a JSON object used by [JsonLocalizationsDelegate]
class JsonLocalizations {
  /// map of translations per language/country code hash
  final Map<String, dynamic> _translations = {};

  /// path to translation assets
  final String assetPath;

  /// the asset bundle
  final AssetBundle assetBundle;

  /// a hash key of language / country code used for [_translationsMap]
  late String _codeKey;

  /// initialize with asset path to JSON files and an optional assetBundle
  JsonLocalizations(this.assetPath, [assetBundle])
      : assetBundle = assetBundle ?? rootBundle;

  /// load and cache a JSON file per language / country code
  Future<JsonLocalizations> load(Locale locale) async {
    final languageCode = locale.languageCode;
    final countryCode = locale.countryCode;

    if (countryCode != null && countryCode.isNotEmpty) {
      _codeKey = '$languageCode-$countryCode';
    } else {
      _codeKey = languageCode;
    }

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
    if (_codeKey != languageCode) {
      _codeKey = languageCode;
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

  /// get translation given a key
  dynamic value(String key) {
    final containsLocale = _translations.containsKey(_codeKey);
    assert(containsLocale, 'Missing translation for code: $_codeKey');
    final jsonObject = _translations[_codeKey]!;
    final containsKey = jsonObject.containsKey(key);
    assert(containsKey, 'Missing localization for key: $key');
    final translatedValue = jsonObject[key];
    return translatedValue;
  }

  /// helper for getting [JsonLocalizations] object
  static JsonLocalizations? of(BuildContext context) =>
      Localizations.of<JsonLocalizations>(context, JsonLocalizations);
}

/// [JsonLocalizationsDelegate] add this to `MaterialApp.localizationsDelegates`
class JsonLocalizationsDelegate
    extends LocalizationsDelegate<JsonLocalizations> {
  final JsonLocalizations localization;

  JsonLocalizationsDelegate(String path, [AssetBundle? assetBundle])
      : localization = JsonLocalizations(path, assetBundle);

  /// we expect all supportedLocales to have asset files
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<JsonLocalizations> load(Locale locale) {
    return localization.load(locale);
  }

  @override
  bool shouldReload(JsonLocalizationsDelegate old) => false;
}
