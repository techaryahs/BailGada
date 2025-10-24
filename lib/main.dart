import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Splashscreen/splash_screen.dart';
import 'firebase_options.dart';
import 'services/translation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final String userKey;
  final translationService = TranslationService();
  await translationService.initialize();
  await translationService.loadLanguagePreference();
  
  runApp(MyApp(translationService: translationService, userKey: "",));
  
  // Preload all supported languages in background
  Future.microtask(() async {
    for (var lang in TranslationService.supportedLanguages) {
      if (lang != 'en') {
        await translationService.preloadLanguage(lang, forceRefresh: false);
      }
    }
  });
}

class MyApp extends StatefulWidget {
  final TranslationService translationService;
  final String userKey;

  const MyApp({super.key, required this.translationService, required this.userKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.translationService.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    widget.translationService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BailGada App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        textTheme: GoogleFonts.notoSansDevanagariTextTheme(
          Theme.of(context).textTheme,
        ),
        fontFamily: GoogleFonts.notoSansDevanagari().fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('mr', ''),
        Locale('en', ''),
      ],
      locale: Locale(widget.translationService.currentLanguage),
      home: SplashScreen(userKey: widget.userKey,),
    );
  }
}


