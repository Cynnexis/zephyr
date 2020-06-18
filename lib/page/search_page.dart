import 'package:flutter/material.dart';
import 'package:zephyr/zephyr_localization.dart';

/// Page that display the search bar and a search button.
class SearchPage extends StatefulWidget {
  final Function(String keywords) onSearch;

  SearchPage({this.onSearch}) : super();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchFieldController = TextEditingController();
  var _enableSearchIcon = true;

  _SearchPageState() : super();

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

  /// Send the [text] to the result page as keywords.
  void _search([String text]) {
    if (text == null) text = _searchFieldController.text.trim();

    // Close the keyboard
    FocusManager.instance.primaryFocus.unfocus();

    widget.onSearch(text);
  }

  /// Build the search page.
  ///
  /// Build the search page, and use [context] to get the parent scaffold if possible.
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                autocorrect: true,
                onSubmitted: _enableSearchIcon ? _search : null,
                decoration: InputDecoration(
                    labelText: ZephyrLocalization.of(context).appName(),
                    hintText: ZephyrLocalization.of(context).searchSign()),
                textInputAction: TextInputAction.search,
                controller: _searchFieldController,
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              tooltip: MaterialLocalizations.of(context).searchFieldLabel,
              onPressed: _enableSearchIcon ? _search : null,
            ),
          ],
        ),
      ),
    );
  }
}
