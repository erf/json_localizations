# json_localizations

A minimal [JSON](https://en.wikipedia.org/wiki/JSON) localization package for Flutter.

Use a JSON file/object per language to represent key/value pairs for localizing your app.

## Install

Add `json_localizations` and `flutter_localizations` as dependencies to your `pubspec.yaml`.

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
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


### Add `JsonLocalizationsDelegate` to `MaterialApp`

Add `JsonLocalizationsDelegate` to `MaterialApp` and set `supportedLocales` using language/country codes.

```
MaterialApp(
  localizationsDelegates: [
    // delegate from flutter_localization
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    // delegate from json_localizations
    JsonLocalizationsDelegate('assets/json_translations'),
  ],
  supportedLocales: [
    Locale('en'),
    Locale('nb'),
  ],
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


## Format

Example JSON file:

```json
{
	"hello": "hello",
	"bye": "bye",
	"items": [ "one", "two", "three" ],
	"count": 1
}
```

> Tip: You can store any json type given a key, like a string, an array of strings, or a number

### API

Get a value for the current language using:

```dart
JsonLocalizations.of(context)?.value('hello')
```

We keep the API simple, but you could easily add an extension method to `String`:

```dart
extension LocalizedString on String {
  String tr(BuildContext context) => JsonLocalizations.of(context)!.value(this);
}
```

So you could write:

```dart
'hello'.tr(context)
```

## Example

See [example](example).
