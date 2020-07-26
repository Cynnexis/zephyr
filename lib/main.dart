import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zephyr/model/history.dart';
import 'package:zephyr/page/favorite_page.dart';
import 'package:zephyr/page/result_page.dart';
import 'package:zephyr/page/search_page.dart';
import 'package:zephyr/service/preferences.dart';
import 'package:zephyr/zephyr_localization.dart';
import 'package:zephyr/zephyr_theme.dart';

import 'model/favorites.dart';
import 'model/keywords.dart';

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

  Widget getActivity({@required BuildContext context, MainActivityState activity}) {
    if (activity == null) activity = this.currentActivityState;

    // Clear the keywords from the search bar
    Provider.of<Keywords>(context, listen: false).clear();

    switch (activity) {
      case MainActivityState.SEARCH:
        return ResultPage(
          defaultPageBuilder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
        );
        break;
      case MainActivityState.FAVORITE:
        return FavoritePage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget tree
    return FutureBuilder<Favorites>(
      future: loadFavorites(),
      builder: (_, favoritesSnapshot) {
        return FutureBuilder(
          future: loadHistory(),
          builder: (context, historySnapshot) {
            if (favoritesSnapshot.connectionState == ConnectionState.done &&
                favoritesSnapshot.data != null &&
                historySnapshot.connectionState == ConnectionState.done &&
                historySnapshot.data != null) {
              return MultiProvider(
                providers: <ChangeNotifierProvider>[
                  ChangeNotifierProvider<Keywords>(create: (context) => Keywords()),
                  ChangeNotifierProvider<Favorites>(create: (context) => favoritesSnapshot.data),
                  ChangeNotifierProvider<History>(create: (context) => historySnapshot.data),
                ],
                builder: (context, _) {
                  // Build the list of items in the drawer
                  List<ListTile> drawerItems = List(MainActivityState.values.length + 1);
                  MainActivityState.values.asMap().forEach((i, activity) {
                    drawerItems[i] = ListTile(
                        key: Key("drawer_item_$i"),
                        leading: activity.icon,
                        title: Text(activity.name(context)),
                        onTap: () {
                          // Close drawer
                          Navigator.pop(context);
                          // Change the activity state if different (avoid refreshing tree)
                          if (currentActivityState != activity) setState(() => currentActivityState = activity);
                        });
                  });

                  var clearSearchHistory = () {
                    History history = Provider.of<History>(context, listen: false);
                    history.clear();
                    saveHistory(history);
                  };

                  drawerItems[MainActivityState.values.length] = ListTile(
                    key: Key("drawer_item_${MainActivityState.values.length}"),
                    leading: Icon(Icons.delete_forever),
                    title: Text("Remove search history"),
                    onTap: () {
                      // Close drawer
                      Navigator.pop(context);
                      // Display a dialog box to confirm the action
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Remove search history"),
                            content: Text("Are you sure you want to remove your search history?"),
                            actions: <Widget>[
                              FlatButton(
                                key: Key("remove_search_history_dialog_no"),
                                child: Text("No"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FlatButton(
                                key: Key("remove_search_history_dialog_yes"),
                                child: Text("Yes"),
                                onPressed: () {
                                  // Remove history and save it
                                  clearSearchHistory();
                                  // Close dialog
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  // Build the main app structure
                  return Scaffold(
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
                            getActivity(context: context),
                            SearchPage(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              // If the favorites are not loaded yet, show a loading screen
              return buildLoadingScreen(context);
            }
          },
        );
      },
    );
  }

  /// Build the application loading screen.
  Widget buildLoadingScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/images/zephyr.png"),
              width: 100,
              height: 100,
            ),
            SizedBox(height: 16),
            Text(widget.title, style: TextStyle(color: Color.fromARGB(100, 255, 255, 255), fontSize: 30)),
            SizedBox(height: 16),
            // Display a circular progress indicator after 2 seconds
            SizedBox(
              width: 30,
              height: 30,
              child: FutureBuilder(
                future: Future.delayed(Duration(seconds: 2)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return CircularProgressIndicator();
                  else
                    return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MainActivityState { SEARCH, FAVORITE }

extension _MainActivityStateExtension on MainActivityState {
  String name(BuildContext context) {
    switch (this) {
      case MainActivityState.SEARCH:
        return ZephyrLocalization.of(context).searchSigns();
      case MainActivityState.FAVORITE:
        return ZephyrLocalization.of(context).favorite();
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
