import 'package:flutter/material.dart';

/// Page that display the search bar and a search button.
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchFieldController = TextEditingController();
  var _enableSearchIcon = true;

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

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
                    final snackbar = SnackBar(
                      content: Text("Searching for \"${_searchFieldController.text}\"..."),
                      duration: Duration(seconds: 2),
                    );
                    Scaffold.of(context).showSnackBar(snackbar);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
