import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Consumer<Favorites>(
      builder: (context, favorites, _) {
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
          // Return the list of favorites
          return SignListPage(signs: favorites.values);
        }
      },
    );
  }
}
