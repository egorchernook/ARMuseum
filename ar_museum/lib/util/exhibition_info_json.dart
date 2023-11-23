import 'dart:ffi';
// import 'dart:ui';

// class LocalizationSensitiveDataInfoJSON {
//   final String languageCode;
//   final String countryCode;
//   final String url;
//
//   LocalizationSensitiveDataInfoJSON.fromJson(Map<String, dynamic> json)
//       : languageCode = json["languageCode"] as String,
//         countryCode = json["countryCode"] as String,
//         url = json["url"] as String;
//
//   MapEntry<Locale, String> toMapEntryLocaleString() {
//     return MapEntry<Locale, String>(Locale(languageCode, countryCode), url);
//   }
// }
//
// Map<Locale, String> convertFromListToMap(
//     List<LocalizationSensitiveDataInfoJSON> list) {
//   return Map<Locale, String>.fromEntries(
//       list.map((element) => element.toMapEntryLocaleString()));
// }

typedef LocalizationSensitiveDataJSON = String;
typedef ExhibitDescriptionJSON = LocalizationSensitiveDataJSON;
typedef ExhibitAudioJSON = LocalizationSensitiveDataJSON;

class ExhibitInfoJSON {
  final int id;
  final List<String> images;
  final String model;

  // final List<ExhibitDescriptionInfoJSON> exhibitDescriptionInfoJSONList;
  // final List<ExhibitAudioInfoJSON> exhibitAudioInfoJSONList;
  final ExhibitDescriptionJSON exhibitDescription;
  final ExhibitAudioJSON exhibitAudio;

  ExhibitInfoJSON.fromJson(Map<String, dynamic> json)
      : id = json["id"] as int,
        images = (json["images"] as List<dynamic>).map((elem) => elem.toString()).toList(),
        model = json["model"] as String,
        exhibitDescription = json["description"] as String,
        exhibitAudio = json["audio"] as String;
// exhibitDescriptionInfoJSONList = (json["description"] as List<dynamic>)
//     .map((item) => ExhibitDescriptionInfoJSON.fromJson(item))
//     .toList(),
// exhibitAudioInfoJSONList = (json["audio"] as List<dynamic>)
//     .map((item) => ExhibitAudioInfoJSON.fromJson(item))
//     .toList();
}

class ExhibitionInfoJSON {
  final List<ExhibitInfoJSON> exhibitInfoJSONList;

  ExhibitionInfoJSON.fromJson(List<dynamic> json)
      : exhibitInfoJSONList =
            json.map((item) => ExhibitInfoJSON.fromJson(item)).toList();
}
