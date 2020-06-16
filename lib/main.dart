import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zephyr/page/search_page.dart';
import 'package:zephyr/zephyr_localization.dart';
import 'package:zephyr/zephyr_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String appName = "Zéphyr";
    return MaterialApp(
      title: appName,
      theme: ZephyrTheme.light,
      darkTheme: ZephyrTheme.dark,
      home: MyHomePage(title: appName),
      localizationsDelegates: [
        const ZephyrLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(title);
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final String title;

  _MyHomePageState(this.title) : super();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      ZephyrTheme.setSystemUIOverlayStyle(brightness: WidgetsBinding.instance.window.platformBrightness);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: ZephyrTheme.getIconThemeData(context),
        title: Text(ZephyrLocalization.of(context).appName(), style: ZephyrTheme.getTextStyle(context)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/zephyr.png"),
                width: 100,
                height: 100,
              ),
              SizedBox(height: 32.0),
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
