// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static m0(suffix) => "Cargando${suffix}";

  static m1(numResults, keywords) =>
      "${Intl.plural(numResults, zero: 'No hay resultados para \"${keywords}\"', one: 'Resultado para \"${keywords}\"', other: 'Resultados para \"${keywords}\"')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "settingAccessibilityM": MessageLookupByLibrary.simpleMessage("Configuración de accesibilidad 🧏‍♂️..."),
        "addToFavorites": MessageLookupByLibrary.simpleMessage("Agregar a los favoritos"),
        "addingMilkAnotherRoom": MessageLookupByLibrary.simpleMessage("Añadiendo leche en otra habitación 🥛..."),
        "appName": MessageLookupByLibrary.simpleMessage("Zéphyr"),
        "balancingRightHandedLeftHanded":
            MessageLookupByLibrary.simpleMessage("Equilibrio entre los contribuyentes diestros y zurdos 👐..."),
        "catGoingToRoom": MessageLookupByLibrary.simpleMessage("🥛🐈🚪"),
        "catsEmojis": MessageLookupByLibrary.simpleMessage("🙀😸😻🐱"),
        "clearTextField": MessageLookupByLibrary.simpleMessage("Borrar texto"),
        "connectingToElix": MessageLookupByLibrary.simpleMessage("Conexión con Elix 🤝..."),
        "cuttingNails": MessageLookupByLibrary.simpleMessage("Manicura de uñas 💅..."),
        "downloadingEmojis":
            MessageLookupByLibrary.simpleMessage("Descargando emojis para las expresiones faciales 🥳"),
        "downloadingSignPuns": MessageLookupByLibrary.simpleMessage("Descargar juegos de palabras firmadas 🙌..."),
        "errorOnlyCatsEmojis": MessageLookupByLibrary.simpleMessage("Error: Emojis de gatos encontrados 😺"),
        "favorite": MessageLookupByLibrary.simpleMessage("Favoritos"),
        "huggingContributors": MessageLookupByLibrary.simpleMessage("Reconocimiento de los contribuyentes 🤗..."),
        "lameSignPunsDetected":
            MessageLookupByLibrary.simpleMessage("Se detectaron malos juegos de palabras... Eliminar 👎..."),
        "loading": m0,
        "loadingFingers": MessageLookupByLibrary.simpleMessage("Cargando los dedos 🖐..."),
        "makingItRock": MessageLookupByLibrary.simpleMessage("Ajuste del rock 🤘..."),
        "makingShadowPuppets":
            MessageLookupByLibrary.simpleMessage("Colocación de sombras chinas ... solo para jugar 🤏"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noSigns": MessageLookupByLibrary.simpleMessage("Sin signos"),
        "openDrawer": MessageLookupByLibrary.simpleMessage("Navegación abierta"),
        "problemSolvedHumanEmojisRetrieved":
            MessageLookupByLibrary.simpleMessage("Problema resuelto: Emojis humanoides descargados 🤓"),
        "removeFromFavorites": MessageLookupByLibrary.simpleMessage("Quitar de favoritos"),
        "removeSearchHistory": MessageLookupByLibrary.simpleMessage("Eliminar historial de búsqueda"),
        "removeSearchHistoryConfirmation":
            MessageLookupByLibrary.simpleMessage("¿Estás seguro de que deseas eliminar tu historial de búsqueda?"),
        "resultsFor": m1,
        "searchButton": MessageLookupByLibrary.simpleMessage("Botón de búsqueda"),
        "searchSign": MessageLookupByLibrary.simpleMessage("Busca una señal"),
        "searchSigns": MessageLookupByLibrary.simpleMessage("Busque Signos"),
        "settingAccessibilityF": MessageLookupByLibrary.simpleMessage("Configuración de accesibilidad 🧏‍♀️..."),
        "triggerVideoExplanation": MessageLookupByLibrary.simpleMessage(
            "Haga clic en el video para reproducirlo y haga clic nuevamente para pausarlo."),
        "yes": MessageLookupByLibrary.simpleMessage("Si")
      };
}
