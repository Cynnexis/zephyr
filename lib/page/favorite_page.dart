import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephyr/model/keywords.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/page/sign_list_page.dart';
import 'package:zephyr/service/preferences.dart';

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
                "Favorites",
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          );
        } else {
          Set<Sign> signs = Set<Sign>.of(favorites.values);

          // Apply filter if keywords are given
          // TODO: When giving keywords, the item dividers in the list are visible.
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
                  "No results for \"${keywords.value}\"",
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
