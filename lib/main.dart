import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tasks/data/setting_model.dart';
import 'package:tasks/data/todos_model.dart';
import 'package:tasks/screens/Home.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tasks/screens/bookmark.dart';
import 'package:tasks/screens/date.dart';
import 'package:tasks/screens/setting.dart';

var settingBox = Hive.box<SettingModel>('settingbox');
SettingModel? settings = settingBox.get('settings');

PersistentTabController _controller = PersistentTabController(initialIndex: 0);
ScrollController _scrollController1 = ScrollController();
ScrollController _scrollController2 = ScrollController();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodomodelAdapter());
  await Hive.openBox<Todomodel>('todobox');
  Hive.registerAdapter(SettingModelAdapter());
  await Hive.openBox<SettingModel>('settingbox');

  var settingBox = Hive.box<SettingModel>('settingbox');
  SettingModel? settings = settingBox.get('settings');
  if (settings == null) {
    settings = SettingModel(
      isdark: false, // تم روشن
      isvibration: true, // ویبره فعال
      isshowdate: true, // نمایش تاریخ
      issund: true,
    );
    await settingBox.put('settings', settings);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<SettingModel>('settingbox').listenable(),
      builder: (context, value, child) {
        var box = Hive.box<SettingModel>('settingbox');
        SettingModel? settings = box.get('settings');
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: (settings?.isdark ?? false)
              ? ThemeData.dark()
              : ThemeData.light(),
          home: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),

            backgroundColor: settings!.isdark
                ? const Color(0xFF0F0F1E) 
                : Colors.white,

            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardAppears: true,
            padding: const EdgeInsets.only(top: 8),
            isVisible: true,
            animationSettings: const NavBarAnimationSettings(
              navBarItemAnimation: ItemAnimationSettings(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimationSettings(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                duration: Duration(milliseconds: 200),
                screenTransitionAnimationType:
                    ScreenTransitionAnimationType.fadeIn,
              ),
            ),

            confineToSafeArea: true,
            navBarHeight: kBottomNavigationBarHeight,
            navBarStyle: NavBarStyle
                .simple, // Choose the nav bar style with this property
          ),
        );
      },
    );
  }

  List<Widget> _buildScreens() {
    return [BookmarkedTasksPage(), Home_Tasks(), DateScreen(), SettingsPage()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.bookmark),
        title: ("Bookmark"),
        activeColorPrimary: CupertinoColors.systemPurple,
        inactiveColorPrimary: settings!.isdark
            ? Colors.white
            : const Color(0xFF0F0F1E),
        scrollController: _scrollController1,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(initialRoute: "/"),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.systemPurple,
        inactiveColorPrimary: settings!.isdark
            ? Colors.white
            : const Color(0xFF0F0F1E),
        scrollController: _scrollController2,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(initialRoute: "/"),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.calendar),
        title: ("Date"),
        activeColorPrimary: CupertinoColors.systemPurple,
        inactiveColorPrimary: settings!.isdark
            ? Colors.white
            : const Color(0xFF0F0F1E),
        scrollController: _scrollController2,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(initialRoute: "/"),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.systemPurple,
        inactiveColorPrimary: settings!.isdark
            ? Colors.white
            : const Color(0xFF0F0F1E),
        scrollController: _scrollController2,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(initialRoute: "/"),
      ),
    ];
  }
}
