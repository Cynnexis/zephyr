import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr/model/favorites.dart';
import 'package:zephyr/model/history.dart';
import 'package:zephyr/model/keywords.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Set<Sign> signs;
  Set<Keywords> keywordsSet;

  group("Preferences (Favorites)", () {
    setUpAll(() async {
      // Create a temporary directory.
      final directory = await Directory.systemTemp.createTemp();

      // Mock out the MethodChannel for the path_provider plugin.
      const MethodChannel('plugins.flutter.io/path_provider').setMockMethodCallHandler((MethodCall methodCall) async {
        // If you're getting the apps documents directory, return the path to the
        // temp directory on the test environment instead.
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return directory.path;
        }
        return null;
      });
    });

    setUp(() {
      signs = <Sign>{
        Sign("test (n.m.)", "https://www.elix-lsf.fr/IMG/mp4/00079-2.mp4",
            definition: "1. procédé qui permet d'évaluer les aptitudes ou les possibilités d'un individu, d'un corps, "
                "d'une substance, d'un système."),
        Sign("minute (n.f.)", "https://www.elix-lsf.fr/IMG/mp4/6_minute_1__nf_1td001-encoded.mp4",
            definition: "1. compte rendu officiel écrit qui relate scrupuleusement ce qui a été dit au cours d'une "
                "réunion."),
        Sign("minute (n.f.)", "https://www.elix-lsf.fr/IMG/mp4/minute_nf_3_1.mp4",
            definition: "3. soixantième partie de l'heure."),
        Sign("chat (n.m.)", "https://www.elix-lsf.fr/IMG/mp4/chat-2.mp4",
            definition: "1. petit mammifère carnassier, familier de l'homme."),
        Sign("équivoque (adj.)", null, definition: "1. qui éveille la méfiance."),
        Sign("ruelle (n.f.)", null,
            definition: "1. voie de communication assez étroite, non goudronnée, souvent en campagne."),
        Sign("Big Bang", null),
      };
      keywordsSet = <Keywords>{
        Keywords("test"),
        Keywords("bleu"),
        Keywords("rouge"),
        Keywords("vert"),
        Keywords("jaune"),
        Keywords("violet"),
        Keywords("rose"),
      };
    });

    test("Saving & Loading Favorites", () async {
      await saveFavorites(signs);
      final Favorites loadedSigns = await loadFavorites();
      expect(signs, equals(loadedSigns.toSet()));
    });

    test("Saving & Loading History", () async {
      await saveHistory(keywordsSet);
      final History loadedHistory = await loadHistory();
      expect(keywordsSet, equals(loadedHistory.toSet()));
    });

    test("Append Favorites", () async {
      await saveFavorites(signs);
      final Set<Sign> newSigns = <Sign>{
        Sign("métro (n.m.)", "https://www.elix-lsf.fr/IMG/mp4/metro_nm_1_1.mp4",
            definition: "1. chemin de fer électrique généralement souterrain qui dessert les quartiers d'une grande "
                "ville."),
        Sign("voiture (n.f.)", "https://www.elix-lsf.fr/IMG/mp4/voiture-2.mp4",
            definition: "1. véhicule à moteur et à quatre roues servant à transporter des personnes."),
        Sign("dictionnaire (n.)", "https://www.elix-lsf.fr/IMG/mp4/00152.mp4",
            definition: "1. liste de termes, structurée ou non, utilisée dans les systèmes documentaires afin de "
                "faciliter l'accès à l'information."),
        Sign("livre (n.m.)", "https://www.elix-lsf.fr/IMG/mp4/livre-3.mp4",
            definition: "1. assemblage de feuilles en un volume, imprimé de signes que l'on lit."),
      };
      final Set<Sign> allSigns = Set.of(signs);
      allSigns.addAll(newSigns);

      await saveFavorites(newSigns, append: true);

      final Set<Sign> loadedSigns = (await loadFavorites()).toSet();
      expect(allSigns, equals(loadedSigns));
    });

    test("Filter", () async {
      await saveFavorites(signs);
      final Set<Sign> newSigns = <Sign>{
        Sign('', null),
        Sign('', ''),
        Sign(null, null),
        Sign(null, "https://www.elix-lsf.fr/IMG/mp4/metro_nm_1_1.mp4",
            definition: "1. chemin de fer électrique généralement souterrain qui dessert les quartiers d'une grande "
                "ville."),
        Sign("voiture (n.f.)", "https://www.elix-lsf.fr/IMG/mp4/voiture-2.mp4",
            definition: "1. véhicule à moteur et à quatre roues servant à transporter des personnes."),
        Sign('', "https://www.elix-lsf.fr/IMG/mp4/00152.mp4",
            definition: "1. liste de termes, structurée ou non, utilisée dans les systèmes documentaires afin de "
                "faciliter l'accès à l'information."),
        Sign("", null, definition: "1. assemblage de feuilles en un volume, imprimé de signes que l'on lit."),
      };
      final Set<Sign> allSigns = Set.of(signs);
      allSigns.add(Sign("voiture (n.f.)", "https://www.elix-lsf.fr/IMG/mp4/voiture-2.mp4",
          definition: "1. véhicule à moteur et à quatre roues servant à transporter des personnes."));

      await saveFavorites(newSigns, append: true);

      final Set<Sign> loadedSigns = (await loadFavorites()).toSet();
      expect(allSigns, equals(loadedSigns));
    });
  });
}
