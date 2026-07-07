import 'package:hive/hive.dart';

part 'setting_model.g.dart';
@HiveType(typeId: 1)
class SettingModel extends HiveObject {

  @HiveField(0)
  bool isdark;

  @HiveField(1)
  bool isvibration;
  @HiveField(2)
  bool isshowdate;

  @HiveField(3)
  bool issund;
  SettingModel({
    required this.isdark,
    required this.isvibration,
    required this.isshowdate,
    required this.issund
  });
}
