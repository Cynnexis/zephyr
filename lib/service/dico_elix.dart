import 'package:html/dom.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/sign_web_scrapper.dart';

/// Web scrapper for Dico Elix, a web dictionary for LSF.
class DicoElix extends SignWebScrapper {
  DicoElix() : super("https://dico.elix-lsf.fr/dictionnaire/");

  @override
  Future<List<Sign>> getSigns(List<String> keywords) async {
    List<Sign> signs = [];
    Document doc = await this.getHtmlParser(this.getUrl(keywords));
    List<Element> words = doc.querySelectorAll("section.word");
    for (Element word in words) {
      // Get all the different words associated to the keywords
      List<Element> meanings = word.querySelectorAll("article.meaning");
      // Get the word as a string
      Element title = word.querySelector("h2.word__title");

      for (Element meaning in meanings) {
        Element video = meaning.querySelector("video");
        Element infos = meaning.querySelector("div.infos");
        String description = infos.querySelector("h3")?.text;
        String sourceUrl = infos.querySelector("a.source")?.attributes["src"];
        if (description != null && sourceUrl != null) {
          description += "\n\n" + infos.querySelector("a.source")?.attributes["src"];
        }

        String videoUrl;
        if (video != null && video.attributes.containsKey("src")) videoUrl = video.attributes["src"];

        signs.add(Sign(
          title.text,
          videoUrl,
          definition: description,
        ));
      }
    }

    return signs;
  }
}

Future<void> main() async {
  DicoElix dicoElix = DicoElix();
  print((await dicoElix.getSigns(["minute"])).join("\n"));
}
