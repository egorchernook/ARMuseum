import 'dart:ffi';
import 'dart:ui';

import 'exhibition_info_json.dart';

class ExhibitInfo {
  final List<String> imagesURL;
  final String modelURL;

  // final Map<Locale, String> exhibitDescriptionURL;
  // final Map<Locale, String> exhibitAudioURL;
  final String exhibitDescriptionURL;
  final String exhibitAudioURL;

  const ExhibitInfo(this.imagesURL, this.modelURL, this.exhibitDescriptionURL,
      this.exhibitAudioURL);
}

class ExhibitionInfo {
  static final ExhibitionInfo _instance = ExhibitionInfo._internal();

  factory ExhibitionInfo() {
    return _instance;
  }

  Map<int, ExhibitInfo> exhibitionData = {};
  ExhibitionInfo._internal();

  ExhibitionInfo.fromJson(List<dynamic> json)
      : exhibitionData = {
          for (var exhibitItem
              in ExhibitionInfoJSON.fromJson(json).exhibitInfoJSONList)
            exhibitItem.id: ExhibitInfo(
                exhibitItem.images,
                exhibitItem.model,
                exhibitItem.exhibitDescription,
                exhibitItem.exhibitAudio)
          // convertFromListToMap(
          //     exhibitItem.exhibitDescriptionInfoJSONList),
          // convertFromListToMap(exhibitItem.exhibitAudioInfoJSONList))
        };
}
