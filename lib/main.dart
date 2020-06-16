import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zephyr/page/search_page.dart';
import 'package:zephyr/zephyr_localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String appName = "Zéphyr";
    return MaterialApp(
      title: appName,
      theme: getTheme(),
      darkTheme: getTheme(Brightness.dark),
      home: MyHomePage(title: appName),
      localizationsDelegates: [
        const ZephyrLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
    );
  }

  ThemeData getTheme([Brightness brightness = Brightness.light]) {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Color(0xff83d5d8),
      accentColor: Color(0xff83d5d8),
      brightness: brightness,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(title);
}

class _MyHomePageState extends State<MyHomePage> {
  final String title;

  _MyHomePageState(this.title) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ZephyrLocalization.of(context).appName()),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.headline4,
              ),
              SearchPage()
            ],
          ),
        ),
      ),
    );
  }
}
