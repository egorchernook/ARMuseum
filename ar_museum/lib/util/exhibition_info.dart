import 'package:ar_museum/util/model_data.dart';

class ExhibitionInfo {
  static final ExhibitionInfo _instance = ExhibitionInfo._internal();

  factory ExhibitionInfo() {
    return _instance;
  }

  ExhibitionInfo._internal() {
    exhibitionData = <String, ModelData>{};
  }

  late Map<String, ModelData> exhibitionData;
}
