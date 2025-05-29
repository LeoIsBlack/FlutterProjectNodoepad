import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/notes_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/note.dart';
import 'services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Map<String, dynamic>? settings;
  try {
    settings = await FirestoreService().loadSettings().timeout(const Duration(seconds: 5));
  } catch (e) {
    print('Ошибка загрузки настроек из Firestore: $e');
    settings = null;
  }

  final isDark = (settings?['themeMode'] ?? 'ThemeMode.light') == 'ThemeMode.dark';
  final languageCode = settings?['languageCode'] ?? 'en';

  runApp(
    MyApp(
      initialThemeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialLocale: Locale(languageCode),
    ),
  );
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  final Locale initialLocale;

  const MyApp({
    super.key,
    required this.initialThemeMode,
    required this.initialLocale,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  late Locale _locale;
  Color _themeColor = Colors.deepPurple;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _locale = widget.initialLocale;
  }

  void _setThemeMode(ThemeMode mode) async {
    final settings = await FirestoreService().loadSettings();
    await FirestoreService().saveSettings(settings?['languageCode'] ?? 'en', mode.toString());
    setState(() {
      _themeMode = mode;
    });
  }

  void _setLocale(Locale locale) async {
    final settings = await FirestoreService().loadSettings();
    await FirestoreService().saveSettings(locale.languageCode, settings?['themeMode'] ?? 'ThemeMode.light');
    setState(() {
      _locale = locale;
    });
  }

  void _setThemeColor(Color color) {
    setState(() {
      _themeColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)?.appTitle ?? 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _themeColor),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MainScreen(
        themeMode: _themeMode,
        locale: _locale,
        themeColor: _themeColor,
        onThemeChanged: _setThemeMode,
        onLocaleChanged: _setLocale,
        onThemeColorChanged: _setThemeColor,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final Locale locale;
  final Color themeColor;
  final void Function(ThemeMode) onThemeChanged;
  final void Function(Locale) onLocaleChanged;
  final void Function(Color) onThemeColorChanged;

  const MainScreen({
    super.key,
    required this.themeMode,
    required this.locale,
    required this.themeColor,
    required this.onThemeChanged,
    required this.onLocaleChanged,
    required this.onThemeColorChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final screens = [
      NotesScreen(),
      SettingsScreen(
        onThemeChanged: widget.onThemeChanged,
        onLocaleChanged: widget.onLocaleChanged,
        themeMode: widget.themeMode,
        locale: widget.locale,
        themeColor: widget.themeColor,
        onThemeColorChanged: widget.onThemeColorChanged,
      ),
      ProfileScreen(),
    ];
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: StreamBuilder<List<Note>>(
        stream: _firestore.getNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return screens[_selectedIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: l10n?.notes ?? 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: l10n?.settings ?? 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: l10n?.profile ?? 'Profile'),
        ],
      ),
    );
  }
}

// ... Остальной код MainScreen, NotesScreen, PubspecAssist (который, видимо, должен быть NotebookScreen)

// ИСПРАВЛЕНИЕ settings_screen.dart (важно!)
// Вам нужно будет открыть lib/screens/settings_screen.dart
// и изменить там import и использование AppLocalizations на AppLocalizations.

/*
// Вот как должен выглядеть settings_screen.dart после исправлений
import 'package:flutter/material.dart';
import 'package:new_app/generated/l10n.dart'; // <--- Правильный импорт

class SettingsScreen extends StatelessWidget {
  final void Function(ThemeMode) onThemeChanged;
  final void Function(Locale) onLocaleChanged;
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLocaleChanged,
    required this.themeMode,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // <--- ИСПОЛЬЗУЕМ AppLocalizations.of(context)!

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)), // Пример использования
      body: Center(
        child: Column(
          children: [
            Text(l10n.settingsPlaceholder), // Пример использования
            // ... остальной код настроек
          ],
        ),
      ),
    );
  }
}
```
*/
