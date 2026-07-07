import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:tasks/data/setting_model.dart';
import 'package:tasks/data/todos_model.dart';
import 'package:tasks/utils/add_todos.dart';
import 'package:tasks/utils/list_Todos.dart';


var settingBox = Hive.box<SettingModel>('settingbox');
SettingModel? settings = settingBox.get('settings');

class Home_Tasks extends StatefulWidget {
  const Home_Tasks({super.key});

  @override
  State<Home_Tasks> createState() => _Home_TasksState();
}

class _Home_TasksState extends State<Home_Tasks> {
  var box = Hive.box<Todomodel>('todobox');
  bool showLottie = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor:  settings!.isdark ? const Color(0xFF0F0F1E) :Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddTodoDialog.show(context);
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),

      appBar: AppBar(
        
        backgroundColor: settings!.isdark ? const Color(0xFF0F0F1E) : Colors.white,
        title: const Text('TIKAD'),
        centerTitle: true,

        // انیمیشن سمت چپ
        leading: GestureDetector(
          onTap: () {
            setState(() {
              showLottie = !showLottie;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Padding(
              padding: const EdgeInsets.only(right: 35),
              child: SizedBox(
                width: 50,
                height: 50,
                child: Lottie.asset(
                  'assets/animations/Catplaying.lottie',
                  fit: BoxFit.cover,
                  repeat: true,
                  reverse: false,
                  animate: true,
                  frameRate: const FrameRate(60),
                ),
              ),
            ),
          ),
        ),

        // انیمیشن سمت راست
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                showLottie = !showLottie;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 52,
                height: 52,
                child: Lottie.asset(
                  'assets/animations/cat.json',
                  fit: BoxFit.contain,
                  repeat: true,
                  reverse: false,
                  animate: true,
                  frameRate: const FrameRate(60),
                ),
              ),
            ),
          ),
        ],
      ),

      body: const SafeArea(child: My_todos()),
    );
  }
}
