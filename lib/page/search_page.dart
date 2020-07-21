import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephyr/model/keywords.dart';
import 'package:zephyr/zephyr_localization.dart';

/// Page that display the search bar and a search button.
class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchFieldController = TextEditingController();
  var _enableSearch = false;

  @override
  void initState() {
    super.initState();

    // Add _searchFieldController as a listener to the app's keywords
    final Keywords keywords = Provider.of<Keywords>(context, listen: false);
    keywords.addListener(() {
      // Change only if the fields are different to avoid unnecessary callback executions.
      if (_searchFieldController.text != keywords.value) _searchFieldController.text = keywords.value;
    });

    // Add _updateSearch() function as a listener for controller changes
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
    bool enableSearch = _searchFieldController.text.trim() != "";
    if (_enableSearch != enableSearch) setState(() => _enableSearch = enableSearch);
  }

  /// Send the [text] to the result page as keywords.
  void _search(BuildContext context, [String text]) {
    if (text == null) text = _searchFieldController.text.trim();
    if (text == null) text = '';

    // Close the keyboard
    FocusManager.instance.primaryFocus.unfocus();

    // Send the new keywords to the result list only if the new text is different
    Keywords keywords = Provider.of<Keywords>(context, listen: false);
    if (keywords.value != text) keywords.value = text;
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
        child: Row(
          children: <Widget>[
            IconButton(
              key: Key("drawer_button"),
              icon: Icon(Icons.menu),
              onPressed: () {
                FocusManager.instance.primaryFocus.unfocus();
                Scaffold.of(context).openDrawer();
              },
            ),
            Expanded(
              child: TextField(
                key: Key("search_signs"),
                autocorrect: true,
                onSubmitted: _enableSearch ? (String text) => _search(context, text) : null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: ZephyrLocalization.of(context).appName(),
                  hintText: ZephyrLocalization.of(context).searchSign(),
                  prefixIcon: FocusScope.of(context).hasFocus
                      ? IconButton(
                          key: Key("search_button"),
                          icon: Icon(Icons.search),
                          onPressed: _enableSearch ? () => _search(context) : null,
                        )
                      : null,
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
          ],
        ),
      ),
    );
  }
}
