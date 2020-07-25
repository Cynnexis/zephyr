import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephyr/model/favorites.dart';
import 'package:zephyr/model/keywords.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/page/sign_list_page.dart';
import 'package:zephyr/zephyr_localization.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Favorites, Keywords>(
      builder: (context, favorites, keywords, _) {
        // Return an home page if no favorites
        if (favorites == null || favorites.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Icon(Icons.favorite, size: 100),
              ),
              SizedBox(height: 32.0),
              Text(
                ZephyrLocalization.of(context).favorite(),
                key: Key("favorite_no_signs"),
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          );
        } else {
          Set<Sign> signs = Set<Sign>.of(favorites.values);

          // Apply filter if keywords are given
          if (keywords != null && !keywords.isEmpty) {
            signs = signs.where((Sign sign) => keywords.matches(sign.word)).toSet();
          }

          if (signs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Icon(Icons.search, size: 100),
                ),
                SizedBox(height: 32.0),
                Text(
                  ZephyrLocalization.of(context).resultsFor(0, keywords.value),
                  style: TextStyle(
                    color: Color.fromARGB(128, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ],
            );
          }

          // Return the list of favorites
          return SignListPage(signs: signs.toList(growable: false));
        }
      },
    );
  }
}
