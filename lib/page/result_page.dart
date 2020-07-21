import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephyr/model/keywords.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/page/sign_list_page.dart';
import 'package:zephyr/service/dico_elix.dart';
import 'package:zephyr/zephyr_localization.dart';

class ResultPage extends StatefulWidget {
  final Widget Function(BuildContext) defaultPageBuilder;

  ResultPage({Key key, this.defaultPageBuilder}) : super(key: key);

  @override
  State createState() => new _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  DicoElix _dicoElix = null;

  /// Result page state constructor.
  _ResultPageState() : super() {
    _dicoElix = DicoElix();
  }

  @override
  Widget build(BuildContext context) {
    // Wait for the signs
    return Consumer<Keywords>(
      builder: (context, keywords, _) => FutureBuilder(
        future: keywords.isEmpty ? Future.value(null) : _dicoElix.getSigns(keywords),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Sign> signs = snapshot.data;

            Widget noResults = Center(
              child: Text(
                "No results",
                style: Theme.of(context).textTheme.headline4,
              ),
            );

            // If no keywords were given, display the default page or the "No Results" page if the former was not given
            if (signs == null) {
              if (widget.defaultPageBuilder != null)
                return widget.defaultPageBuilder(context);
              else
                return noResults;
            }

            // If no results were returned
            if (signs.isEmpty) return noResults;

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
      ),
    );
  }
}
