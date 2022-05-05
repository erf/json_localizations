import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:json_localizations/json_localizations.dart';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    return Future.error('Not implemented');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) {
    if (key.endsWith('en.json')) {
      return Future.value('{"hi": "Hi"}');
    }
    if (key.endsWith('en-US.json')) {
      return Future.value('{"hi": "Hi en-US"}');
    }
    if (key.endsWith('nb.json')) {
      return Future.value('{"hi": "Hei"}');
    }
    throw Exception('Not implemented');
  }
}

Widget buildTestWidgetWithLocale(Locale locale) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: [
      JsonLocalizationsDelegate(
        'assets/json_translations',
        TestAssetBundle(),
      ),
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('en', 'US'),
      Locale('nb'),
      Locale('nb', 'NO'),
    ],
    home: Scaffold(
      body: Builder(
        builder: (context) =>
            Text(JsonLocalizations.of(context)?.value('hi') ?? ''),
      ),
    ),
  );
}

void main() {
  testWidgets('Find Hi [en]', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidgetWithLocale(const Locale('en')));
    await tester.pump();
    final hiFinder = find.text('Hi');
    expect(hiFinder, findsOneWidget);
  });

  testWidgets('Find Hei [nb]', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidgetWithLocale(const Locale('nb')));
    await tester.pump();
    final hiFinder = find.text('Hei');
    expect(hiFinder, findsOneWidget);
  });

  testWidgets('Find Hi [en-US]', (WidgetTester tester) async {
    await tester
        .pumpWidget(buildTestWidgetWithLocale(const Locale('en', 'US')));
    await tester.pump();
    final hiFinder = find.text('Hi en-US');
    expect(hiFinder, findsOneWidget);
  });

  test('Locale get codeKey from languageCode', () {
    expect(const Locale('en').toLanguageTag(), 'en');
    expect(const Locale('nb').toLanguageTag(), 'nb');
  });

  test('Locale get codeKey from languageCode and country', () {
    expect(const Locale('en', 'US').toLanguageTag(), 'en-US');
    expect(const Locale('en', 'GB').toLanguageTag(), 'en-GB');
  });
}
