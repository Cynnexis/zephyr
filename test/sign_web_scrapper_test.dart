import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:html/dom.dart';
import 'package:matcher/matcher.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/sign_web_scrapper.dart';

class SignWebScrapperTest extends SignWebScrapper {
  SignWebScrapperTest() : super("https://webscraper.io/test-sites/");

  @override
  Future<List<Sign>> getSigns(List<String> keywords) {
    return Future.value(<Sign>[]);
  }
}

void main() {
  group("Sign Web Scrapper", () {
    test("Instantiation", () => SignWebScrapperTest());

    test("Get HTML Parser", () async {
      // ignore: invalid_use_of_protected_member
      Document doc = await SignWebScrapperTest().getHtmlParser("https://webscraper.io/test-sites/tables");
      expect(doc, isNotNull);

      List<Element> tables = doc.querySelectorAll(".table.table-bordered");
      expect(tables, hasLength(4));

      // ignore: invalid_use_of_protected_member
      expect(SignWebScrapperTest().getHtmlParser("https://webscraper.io/test-sites/this-is-not-a-good-url-404"),
          throwsA(TypeMatcher<HttpException>()));
    });

    test("Get URL", () {
      SignWebScrapperTest scrapper = SignWebScrapperTest();

      expect(scrapper.getUrl(["tables"]), equals("https://webscraper.io/test-sites/tables"));
      expect(scrapper.getUrl(["tables"], '-'), equals("https://webscraper.io/test-sites/tables"));
      expect(scrapper.getUrl(["tables"], "    "), equals("https://webscraper.io/test-sites/tables"));

      expect(scrapper.getUrl(["e-commerce/scroll"]), equals("https://webscraper.io/test-sites/e-commerce/scroll"));
      expect(scrapper.getUrl(["e-commerce scroll"], '/'), equals("https://webscraper.io/test-sites/e-commerce/scroll"));
      expect(
          scrapper.getUrl(["e-commerce", "scroll"], '/'), equals("https://webscraper.io/test-sites/e-commerce/scroll"));
    });
  });
}
