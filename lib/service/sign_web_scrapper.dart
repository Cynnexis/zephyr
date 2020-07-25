import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:zephyr/model/keywords.dart';
import 'package:zephyr/model/sign.dart';

/// Abstract class for web scrapping for sign language.
abstract class SignWebScrapper {
  String baseUrl;

  /// Constructor for the web scrapping.
  ///
  /// Construct the base for web scrapping. [baseUrl] is the URL to the site without the keywords. For instance, it
  /// can be "https://example.com/signes/?q=".
  SignWebScrapper(this.baseUrl);

  /// Downloads the page at [url] and return the DOM parser.
  ///
  /// Throws an [HttpException] if the status code is not valid.
  @protected
  Future<Document> getHtmlParser(String url, {Map<String, String> headers}) async {
    Client client = Client();
    Response response = await client.get(url, headers: headers);
    if (response.statusCode < 200 || response.statusCode >= 300)
      throw HttpException("Could not connect to \"$url\". Status code: ${response.statusCode}");

    Document doc = parse(response.body);
    return doc;
  }

  /// Returns the complete URL with the keywords.
  ///
  /// Add the given keywords at the end of the [baseUrl], by replacing the whitespaces in the [keywords] by
  /// [whitespaceReplacement], and joining them with [whitespaceReplacement] as well.
  String getUrl(Keywords keywords, [String whitespaceReplacement = '+']) {
    return baseUrl +
        [for (var keyword in keywords.valueAsKeywordsList) keyword.replaceAll(' ', whitespaceReplacement)]
            .join(whitespaceReplacement);
  }

  /// Returns a list of all signs scrapped from the website from the given [keywords].
  ///
  /// This function is asynchronous.
  Future<List<Sign>> getSigns(Keywords keywords);
}
