import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zephyr/page/result_page.dart';
import 'package:zephyr/page/search_page.dart';
import 'package:zephyr/service/preferences.dart';
import 'package:zephyr/zephyr_localization.dart';
import 'package:zephyr/zephyr_theme.dart';

import 'model/keywords.dart';

// TODO: Translate app
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
  MainActivityState currentActivityState = MainActivityState.SEARCH;

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

  List<Widget> getActivity(Keywords keywords, {MainActivityState activity}) {
    if (activity == null) activity = this.currentActivityState;

    switch (activity) {
      case MainActivityState.SEARCH:
        if (keywords != null && !keywords.isEmpty) {
          return <Widget>[Expanded(child: ResultPage(keywords: keywords))];
        } else {
          return <Widget>[
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
          ];
        }
        break;
      case MainActivityState.FAVORITE:
        return <Widget>[
          Center(
            child: Icon(Icons.favorite, size: 100),
          ),
          SizedBox(height: 32.0),
          Text(
            activity.name,
            style: Theme.of(context).textTheme.headline4,
          ),
        ];
      default:
        return <Widget>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> drawerItems = List(MainActivityState.values.length);

    // Build the list of items in the drawer
    MainActivityState.values.asMap().forEach((i, activity) {
      drawerItems[i] = ListTile(
          leading: activity.icon,
          title: Text(activity.name),
          onTap: () {
            // Close drawer
            Navigator.pop(context);
            // Change the activity state if different (avoid refreshing tree)
            if (currentActivityState != activity) setState(() => currentActivityState = activity);
          });
    });

    // Build the widget tree
    return FutureBuilder<Favorites>(
      future: loadFavorites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return MultiProvider(
            providers: <ChangeNotifierProvider>[
              ChangeNotifierProvider<Keywords>(create: (context) => Keywords()),
              ChangeNotifierProvider<Favorites>(create: (context) => snapshot.data),
            ],
            child: Scaffold(
              drawer: Drawer(
                key: Key("drawer"),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                        DrawerHeader(
                          decoration: BoxDecoration(color: ZephyrTheme.primaryColor),
                          child: Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 24)),
                        ),
                      ] +
                      drawerItems,
                ),
              ),
              body: Padding(
                padding: EdgeInsets.only(top: 22.0),
                child: Center(
                  child: Stack(
                    fit: StackFit.loose,
                    children: <Widget>[
                      Consumer<Favorites>(
                        builder: (context, favorites, child) {
                          return Consumer<Keywords>(
                            builder: (context, keywords, child) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: getActivity(keywords),
                              );
                            },
                          );
                        },
                      ),
                      SearchPage(),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else
          return Center(
            child: Image(
              image: AssetImage("assets/images/zephyr.png"),
              width: 100,
              height: 100,
            ),
          );
      },
    );
  }
}

enum MainActivityState { SEARCH, FAVORITE }

extension _MainActivityStateExtension on MainActivityState {
  String get name {
    switch (this) {
      case MainActivityState.SEARCH:
        return "Search Signs";
      case MainActivityState.FAVORITE:
        return "Favorite";
      default:
        return "";
    }
  }

  Icon get icon {
    switch (this) {
      case MainActivityState.SEARCH:
        return Icon(Icons.search);
      case MainActivityState.FAVORITE:
        return Icon(Icons.favorite);
      default:
        return Icon(Icons.error);
    }
  }
}
