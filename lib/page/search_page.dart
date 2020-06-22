import 'package:flutter/material.dart';
import 'package:zephyr/zephyr_localization.dart';

/// Page that display the search bar and a search button.
class SearchPage extends StatefulWidget {
  final Function(String keywords) onSearch;

  SearchPage({Key key, this.onSearch}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchFieldController = TextEditingController();
  var _enableSearch = false;

  _SearchPageState() : super();

  @override
  void initState() {
    super.initState();
    _searchFieldController.addListener(this._updateSearch);
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
  void _updateSearch() {
    setState(() {
      _enableSearch = _searchFieldController.text.trim() != "";
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
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: TextField(
          key: ValueKey("search_signs"),
          autocorrect: true,
          onSubmitted: _enableSearch ? _search : null,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: ZephyrLocalization.of(context).appName(),
            hintText: ZephyrLocalization.of(context).searchSign(),
            prefixIcon: IconButton(
              key: Key("search_button"),
              icon: Icon(Icons.search),
              onPressed: _enableSearch ? _search : null,
            ),
            suffixIcon: _enableSearch
                ? IconButton(
                    key: Key("clear_search_button"),
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchFieldController.clear();
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                  )
                : null,
          ),
          textInputAction: TextInputAction.search,
          controller: _searchFieldController,
        ),
      ),
    );
  }
}
