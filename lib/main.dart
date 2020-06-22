import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zephyr/page/result_page.dart';
import 'package:zephyr/page/search_page.dart';
import 'package:zephyr/zephyr_localization.dart';
import 'package:zephyr/zephyr_theme.dart';

void main() => runApp(ZephyrApp());

class ZephyrApp extends StatelessWidget {
  final String appName = "Zéphyr";

  const ZephyrApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: Key("zephyr_app"),
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ZephyrTheme.light,
      darkTheme: ZephyrTheme.dark,
      home: ZephyrHome(title: appName),
      localizationsDelegates: [
        const ZephyrLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
    );
  }
}

class ZephyrHome extends StatefulWidget {
  final String title;

  ZephyrHome({Key key, this.title}) : super(key: key);

  @override
  _ZephyrHomeState createState() => _ZephyrHomeState();
}

class _ZephyrHomeState extends State<ZephyrHome> with WidgetsBindingObserver {
  String keywords = null;

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
      body: Padding(
        padding: EdgeInsets.only(top: 22.0),
        child: Center(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: keywords != null
                    ? <Widget>[Expanded(child: ResultPage(keywords: keywords))]
                    : <Widget>[
                        Center(
                          child: Image(
                            image: AssetImage("assets/images/zephyr.png"),
                            width: 100,
                            height: 100,
                          ),
                        ),
                        SizedBox(height: 32.0),
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
              ),
              SearchPage(
                onSearch: (keywords) => setState(() {
                  print("New keywords: $keywords");
                  this.keywords = keywords;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
