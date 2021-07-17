# json_localizations

A minimal [JSON](https://en.wikipedia.org/wiki/JSON) localization package for Flutter.

Use a JSON object / file per language to represent key / value pairs for localizing your app.

Also consider [toml_localizations](https://github.com/erf/toml_localizations), [yaml_localizations](https://github.com/erf/yaml_localizations) and [csv_localizations](https://github.com/erf/csv_localizations).

## Usage

See [example](example).

### Install

Add to your `pubspec.yaml`

```yaml
dependencies:
  json_localizations:
```

### Add a JSON file per language

Add a JSON file per language you support in an asset `path` and describe it in your `pubspec.yaml`

```yaml
flutter:
  assets:
    - assets/json_translations/
```

The JSON file name must match exactly the combination of language and country code described in `supportedLocales`.

That is `Locale('en', 'US')` must have a corresponding `assetPath/en-US.json` file.


##### Example JSON file

```json
{
	"hello": "hello",
	"bye": "bye",
	"items": [ "one", "two", "three" ],
	"count": 1
}
```

> Tip: You can store any json type given a key, like a string, an array of strings, or a number

### MaterialApp

Add `JsonLocalizationsDelegate` to `MaterialApp` and set `supportedLocales` using language/country codes.

```
MaterialApp(
  localizationsDelegates: [
    ... // global delegates
    JsonLocalizationsDelegate('assets/json_translations'),
  ],
  supportedLocales: [
    Locale('en'),
    Locale('nb'),
  ],
}

```

### API

Translate strings or a list of strings using `value`:

```dart
JsonLocalizations.of(context)?.value('hello')
```

We keep the API simple, but you can easily add an extension method to `String` like this:

```dart
extension LocalizedString on String {
  String tr(BuildContext context) => JsonLocalizations.of(context)!.value(this);
}
```

### Note on **iOS**

Add supported languages to `ios/Runner/Info.plist` as described 
[here](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#specifying-supportedlocales).

Example:

```
<key>CFBundleLocalizations</key>
<array>
	<string>en-GB</string>
	<string>en</string>
	<string>nb</string>
</array>
```
