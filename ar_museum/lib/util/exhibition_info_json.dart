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

typedef LocalizationSensitiveDataInfoJSON = String;
typedef ExhibitDescriptionInfoJSON = LocalizationSensitiveDataInfoJSON;
typedef ExhibitAudioInfoJSON = LocalizationSensitiveDataInfoJSON;

class ExhibitInfoJSON {
  final Uint64 id;
  final String imagesURL;
  final String modelsURL;
  // final List<ExhibitDescriptionInfoJSON> exhibitDescriptionInfoJSONList;
  // final List<ExhibitAudioInfoJSON> exhibitAudioInfoJSONList;
  final ExhibitDescriptionInfoJSON exhibitDescriptionInfoURL;
  final ExhibitAudioInfoJSON exhibitAudioInfoURL;

  ExhibitInfoJSON.fromJson(Map<String, dynamic> json)
      : id = json["id"] as Uint64,
        imagesURL = json["imagesURL"] as String,
        modelsURL = json["modelsURL"] as String,
        exhibitDescriptionInfoURL = json["description"] as String,
        exhibitAudioInfoURL = json["audio"] as String;
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
