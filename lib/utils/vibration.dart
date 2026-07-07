import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:tasks/data/setting_model.dart';

Future<void> vibratin ()async{
    var settingBox = Hive.box<SettingModel>('settingbox');
  SettingModel? settings = settingBox.get('settings');
  if (settings!.isvibration == true) {
    HapticFeedback.mediumImpact();
  } else {
    null;
  }
}