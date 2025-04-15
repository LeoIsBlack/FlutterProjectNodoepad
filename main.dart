import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.system
              ? ThemeMode.light
              : _themeMode == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.system;
    });
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('kk', 'KZ'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('kk');
        return supportedLocales.firstWhere(
          (supportedLocale) =>
              supportedLocale.languageCode == locale.languageCode,
          orElse: () => const Locale('kk'),
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.indigo,
          secondary: Colors.pinkAccent,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(8),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            elevation: 2,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.indigo,
          secondary: Colors.indigoAccent,
        ),
        cardTheme: CardTheme(color: Colors.indigo[900]),
      ),
      home: HomePage(
        onThemeToggle: _toggleTheme,
        onLanguageChange: _changeLanguage,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final Function(Locale) onLanguageChange;

  const HomePage({
    required this.onThemeToggle,
    required this.onLanguageChange,
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _notes = [];
  bool _showWelcomeMessage = true;
  TextEditingController _noteController = TextEditingController();

  String get _welcomeMessage {
    switch (Localizations.localeOf(context).languageCode) {
      case 'ru':
        return 'Добро пожаловать в приложение!';
      case 'kk':
        return 'Қосымшаға қош келдіңіз!';
      default:
        return 'Welcome to Notes App!';
    }
  }

  String get _appTitle {
    switch (Localizations.localeOf(context).languageCode) {
      case 'ru':
        return 'Мои заметки';
      case 'kk':
        return 'Менің жазбаларым';
      default:
        return 'My Notes';
    }
  }

  void _addNote() {
    final note = _noteController.text.trim();
    if (note.isNotEmpty) {
      setState(() {
        _notes.add(note);
        _noteController.clear();
      });
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Language'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LanguageOption(
                  locale: const Locale('en', 'US'),
                  language: 'English',
                  flag: '🇬🇧',
                  onSelected: widget.onLanguageChange,
                ),
                _LanguageOption(
                  locale: const Locale('ru', 'RU'),
                  language: 'Русский',
                  flag: '🇷🇺',
                  onSelected: widget.onLanguageChange,
                ),
                _LanguageOption(
                  locale: const Locale('kk', 'KZ'),
                  language: 'Қазақша',
                  flag: '🇰🇿',
                  onSelected: widget.onLanguageChange,
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_appTitle),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _showLanguageDialog,
            tooltip: 'Select Language',
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onThemeToggle,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showWelcomeMessage)
              GestureDetector(
                onLongPress: () => setState(() => _showWelcomeMessage = false),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    _welcomeMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Add a new note...',
                hintText: 'Write something important...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: colorScheme.primary),
                  onPressed: _addNote,
                ),
              ),
              minLines: 1,
              maxLines: 3,
              onSubmitted: (_) => _addNote(),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Notes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  _notes.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.note_add_outlined,
                              size: 64,
                              color: colorScheme.onBackground.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No notes yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: colorScheme.onBackground.withOpacity(
                                  0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: _notes.length,
                        itemBuilder:
                            (context, index) => Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _notes[index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red[400],
                                          ),
                                          onPressed:
                                              () => setState(
                                                () => _notes.removeAt(index),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('Add New Note'),
                  content: TextField(
                    controller: _noteController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Write your note here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _addNote();
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final Locale locale;
  final String language;
  final String flag;
  final Function(Locale) onSelected;

  const _LanguageOption({
    required this.locale,
    required this.language,
    required this.flag,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(language),
      onTap: () {
        onSelected(locale);
        Navigator.of(context).pop();
      },
    );
  }
}
