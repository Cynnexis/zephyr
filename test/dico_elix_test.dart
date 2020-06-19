import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/dico_elix.dart';

void main() {
  DicoElix dicoElix;

  group("Dico Elix", () {
    setUp(() => dicoElix = DicoElix());

    test("Get \"test\"", () async {
      List<Sign> testSigns = await dicoElix.getSigns(["test"]);

      expect(testSigns, hasLength(3));
      for (Sign testSign in testSigns) {
        expect(testSign.word, equals("test (n.m.)"));
        expect(testSign.videoUrl, isNotNull);
      }
    });

    test("Get \"minute\"", () async {
      List<Sign> minuteSigns = await dicoElix.getSigns(["minute"]);

      expect(minuteSigns, hasLength(8));
      for (int i = 0; i < 6; i++) expect(minuteSigns[i].word, equals("minute (n.f.)"));

      expect(minuteSigns[6].word, equals("minute ! (int.)"));
      expect(minuteSigns[7].word, equals("minuter (v.)"));

      for (int i = 0; i < minuteSigns.length; i++) {
        if (i != 1)
          expect(minuteSigns[i].videoUrl, isNotNull);
        else
          expect(minuteSigns[i].videoUrl, isNull);
      }
    });

    test("Get \"ZZZ\"", () async {
      List<Sign> zzzSigns = await dicoElix.getSigns(["ZZZ"]);
      expect(zzzSigns, isEmpty);
    });
  });
}
