import 'dart:ffi';
import 'dart:ui';

import 'exhibition_info_json.dart';

class ExhibitInfo {
  final String imagesURL;
  final String modelsURL;
  final Map<Locale, String> exhibitDescriptionURL;
  final Map<Locale, String> exhibitAudioURL;

  const ExhibitInfo(this.imagesURL, this.modelsURL, this.exhibitDescriptionURL,
      this.exhibitAudioURL);
}

class ExhibitionInfo {
  static final ExhibitionInfo _instance = ExhibitionInfo._internal();

  factory ExhibitionInfo() {
    return _instance;
  }

  late Map<Uint64, ExhibitInfo> exhibitionData;

  ExhibitionInfo._internal() {
    exhibitionData = <Uint64, ExhibitInfo>{};
  }

  ExhibitionInfo.fromJson(List<dynamic> json)
      : exhibitionData = {
          for (var exhibitItem
              in ExhibitionInfoJSON.fromJson(json).exhibitInfoJSONList)
            exhibitItem.id: ExhibitInfo(
                exhibitItem.imagesURL,
                exhibitItem.modelsURL,
                convertFromListToMap(
                    exhibitItem.exhibitDescriptionInfoJSONList),
                convertFromListToMap(exhibitItem.exhibitAudioInfoJSONList))
        };
}
