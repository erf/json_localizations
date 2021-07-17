import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:json_localizations/json_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        JsonLocalizationsDelegate(
          'assets/json_translations',
          DefaultAssetBundle.of(context),
        ),
      ],
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('nb'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('json_localizations'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(JsonLocalizations.of(context)?.value('hello')),
          const SizedBox(height: 12),
          Text(JsonLocalizations.of(context)?.value('bye')),
          const Divider(),
          ...JsonLocalizations.of(context)
              ?.value('items')
              .map((text) => Text(text))
              .toList(),
          const Divider(),
          Text(JsonLocalizations.of(context)!.value('count').toString()),
        ],
      ),
    );
  }
}
