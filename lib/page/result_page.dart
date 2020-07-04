import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zephyr/model/keywords.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/page/sign_list_page.dart';
import 'package:zephyr/service/dico_elix.dart';
import 'package:zephyr/zephyr_localization.dart';

class ResultPage extends StatefulWidget {
  final Keywords keywords;

  ResultPage({Key key, this.keywords}) : super(key: key);

  @override
  State createState() => new _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  DicoElix _dicoElix = null;
  Future<List<Sign>> futureSigns = null;

  /// Result page state constructor.
  ///
  /// [keywords] is the list of keywords (it can be one or multiple items separated by whitespaces), and they will be
  /// used then by  [dicoElix] to fetch the [signs] if not provided by the users.
  _ResultPageState() : super() {
    _dicoElix = DicoElix();
  }

  @override
  Widget build(BuildContext context) {
    // Wait for the signs
    if (widget.keywords == null) throw "keywords cannot be null.";

    futureSigns = _dicoElix.getSigns(widget.keywords);

    return FutureBuilder(
      future: futureSigns,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Sign> signs = snapshot.data;

          // If no results were returned
          if (signs == null || signs.isEmpty) {
            return Center(
              child: Text(
                "No results",
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          }

          return SignListPage(signs: signs);
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(key: Key("loading_signs_results")),
                SizedBox(height: 32),
                Text(ZephyrLocalization.of(context).loading()),
              ],
            ),
          );
        }
      },
    );
  }
}
