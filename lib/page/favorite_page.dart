import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
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
  }
}
