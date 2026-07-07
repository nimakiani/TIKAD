import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:tasks/data/setting_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tasks/data/todos_model.dart';
import 'package:tasks/utils/playsaund.dart';

final player = AudioPlayer();

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isDark =  Hive.box<SettingModel>('settingbox').get('settings')?.isdark ?? true;
    var box = Hive.box<SettingModel>('settingbox');
    SettingModel? settings = box.get('settings');
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F1E) : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F0F1E) : Colors.grey.shade50,
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          const _SectionTitle(title: 'APPEARANCE'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable Dark Mode'),
            value: settings?.isdark ?? false,
            onChanged: (value) async {
              // 1. دریافت باکس
              var settingBox = Hive.box<SettingModel>('settingbox');

              // 2. دریافت تنظیمات
              SettingModel? settings = settingBox.get('settings');

              // 3. تغییر مقدار
              if (settings != null) {
                settings.isdark = value;
                await settingBox.put('settings', settings); // ✅ ذخیره

                // 4. دیباگ - ببین مقدار تغییر کرده؟
                print('تم تغییر کرد: ${settings.isdark}');
              }
            },
          ),

          const Divider(height: 32),

          // Notifications Section
          const _SectionTitle(title: 'NOTIFICATIONS'),
          SwitchListTile(
            title: const Text('Vibration'),
            subtitle: const Text('Vibrate when adding a task'),
            value: settings?.isvibration ?? true,
            onChanged: (value) async {
              if (settings != null) {
                settings.isvibration = value;
                await box.put('settings', settings); // ✅ استفاده از put

                if (value) {
                  HapticFeedback.mediumImpact();
                }
              }
            },
          ),

          SwitchListTile(
            title: const Text('Sound'),
            subtitle: const Text('Play sound when todo is finished'),
            value: settings?.issund ?? true,
            onChanged: (value) async {
              if (settings != null) {
                settings.issund = value;
                await box.put('settings', settings); // ✅ استفاده از put

                if (value) {
                  playsaund();
                }
              }
            },
          ),

          const Divider(height: 32),

          // Data Management
          const _SectionTitle(title: 'DATA MANAGEMENT'),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
            title: const Text('Clear All Tasks'),
            textColor: Colors.redAccent,
            onTap: _showClearDataDialog,
          ),

          const Divider(height: 32),

          // About
          const _SectionTitle(title: 'ABOUT'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About TIKAD'),
            onTap: () => _showAboutDialog(context),
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    var box = Hive.box<Todomodel>('todobox');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Warning'),
        content: const Text(
          'Are you sure you want to permanently delete all tasks?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await box.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All tasks have been cleared')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TIKAD',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.task_alt,
        size: 52,
        color: Color(0xFF8B6EFF),
      ),
      children: const [Text('A clean and simple task management app.')],
    );
  }
}

// Helper Widget
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B6EFF),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
