import 'package:flutter/material.dart';
import 'package:zephyr/page/result_page.dart';

/// Page that display the search bar and a search button.
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchFieldController = TextEditingController();
  var _enableSearchIcon = true;

  @override
  void initState() {
    super.initState();
    _searchFieldController.addListener(this._updateSearchButton);
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  /// Update the search button state according to the search field text emptiness.
  /// 
  /// If the search text field is empty, the search button is disabled, otherwise it is enable. The text is known
  /// through [_searchFieldController]. This function is designed to be used as a callback by
  /// [TextEditingController].
  void _updateSearchButton() {
    setState(() {
      _enableSearchIcon = _searchFieldController.text.trim() != "";
    });
  }

  /// Build the search page.
  ///
  /// Build the search page, and use [context] to get the parent scaffold if possible.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              autocorrect: true,
              onSubmitted: null,
              decoration: InputDecoration(
                border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.grey)),
                labelText: "Search a sign",
                hintText: "Bonjour, au revoir, merci, ...", // TODO: Make dynamic list
              ),
              controller: _searchFieldController,
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            tooltip: "Search",
            onPressed: _enableSearchIcon
                ? () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResultPage([_searchFieldController.text])),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
