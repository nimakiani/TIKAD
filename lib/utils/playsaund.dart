import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';
import 'package:tasks/data/setting_model.dart';

final playerr = AudioPlayer();
Future<void> playsaund() async{
  var settingBox = Hive.box<SettingModel>('settingbox');
  SettingModel? settings = settingBox.get('settings');
String audiopath = 'audio/ii.mp3';
 

  if (settings!.issund == true) {
     playerr.play(AssetSource(audiopath));
  } else {
    null;
  }
}