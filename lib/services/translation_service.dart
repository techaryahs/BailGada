import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService extends ChangeNotifier {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  static const String defaultLanguage = 'mr';
  static const List<String> supportedLanguages = ['mr', 'en'];
  
  static const Map<String, String> _apiUrls = {
    'mr': 'https://evoblack-libretranslate-marathi.hf.space',
    'en': 'https://evoblack-libretranslate-marathi.hf.space',
  };

  static final Map<String, String> _baseTexts = {
    // Navigation
    'home': 'Home',
    'profile': 'Profile',
    'settings': 'Settings',
    'driver': 'Driver',
    'host': 'Host',
    
    // Events
    'events': 'Events',
    'current_events': 'Current Events',
    'upcoming_events': 'Upcoming Events',
    'past_events': 'Past Events',
    'event_details': 'Event Details',
    'my_events': 'My Events',
    
    // Actions
    'login': 'Login',
    'logout': 'Logout',
    'save': 'Save',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'edit': 'Edit',
    'create': 'Create',
    'update': 'Update',
    'submit': 'Submit',
    'search': 'Search',
    
    // Driver Dashboard
    'driver_dashboard': 'Driver Dashboard',
    'total_races_completed': 'Total Races Completed',
    'races_won': 'Races Won',
    'average_speed': 'Average Speed',
    'total_earnings': 'Total Earnings',
    'my_races': 'My Races',
    'race_history': 'Race History',
    
    // Host Dashboard
    'host_dashboard': 'Host Dashboard',
    'create_event': 'Create Event',
    'applications': 'Applications',
    'payments': 'Payments',
    'total_events_hosted': 'Total Events Hosted',
    'total_revenue': 'Total Revenue',
    'active_participants': 'Active Participants',
    'event_analytics': 'Event Analytics',
    
    // Carousel
    'carousel_title_1': 'Welcome to BullCart Race',
    'carousel_subtitle_1': 'Feel the speed, embrace the tradition',
    'carousel_title_2': 'Join as Driver',
    'carousel_subtitle_2': 'Compete in thrilling races',
    'carousel_title_3': 'Host Events',
    'carousel_subtitle_3': 'Organize and manage races',
    
    // Common
    'welcome': 'Welcome',
    'loading': 'Loading',
    'error': 'Error',
    'success': 'Success',
    'no_data': 'No data available',
    'try_again': 'Try Again',
    'language': 'Language',
    'select_language': 'Select Language',
    
    // Profile
    'edit_profile': 'Edit Profile',
    'change_password': 'Change Password',
    'notifications': 'Notifications',
    'privacy': 'Privacy',
    'terms': 'Terms & Conditions',
    'about': 'About',
    'help': 'Help',
    
    // Leaderboard
    'leaderboard': 'Leaderboard',
    'rank': 'Rank',
    'name': 'Name',
    'score': 'Score',
    'wins': 'Wins',
    'top_racers': 'Top Racers',
    'view_full_leaderboard': 'View Full Leaderboard',
    'no_ongoing_upcoming_events': 'No ongoing or upcoming events found.',
    'points': 'pts',
    
    // Racer Names (for demo/hardcoded data)
    // Note: Names are provided in both scripts, not translated by API
    'rohit_pawar': 'Rohit Pawar',
    'suresh_patil': 'Suresh Patil',
    'vikram_jadhav': 'Vikram Jadhav',
    'nitin_gaikwad': 'Nitin Gaikwad',
    'rajesh_shinde': 'Rajesh Shinde',
    
    // Marathi versions of names (manually provided)
    'rohit_pawar_mr': 'रोहित पवार',
    'suresh_patil_mr': 'सुरेश पाटील',
    'vikram_jadhav_mr': 'विक्रम जाधव',
    'nitin_gaikwad_mr': 'नितीन गायकवाड',
    'rajesh_shinde_mr': 'राजेश शिंदे',
    
    // Authentication
    'sign_in': 'Sign In',
    'sign_up': 'Sign Up',
    'email': 'Email',
    'password': 'Password',
    'confirm_password': 'Confirm Password',
    'phone': 'Phone Number',
    'full_name': 'Full Name',
    'remember_me': 'Remember Me',
    'forgot_password': 'Forgot Password?',
    'dont_have_account': "Don't have an account?",
    'already_have_account': 'Already have an account?',
    'create_account': 'Create Account',
    'register': 'Register',
    'accept_terms': 'I accept the Terms and Conditions',
    'welcome_back': 'Welcome Back',
    'create_new_account': 'Create New Account',
    'enter_email': 'Enter your email',
    'enter_password': 'Enter your password',
    'enter_phone': 'Enter your phone number',
    'enter_name': 'Enter your full name',
    'invalid_email': 'Please enter a valid email',
    'password_too_short': 'Password must be at least 6 characters',
    'passwords_dont_match': 'Passwords do not match',
    'field_required': 'This field is required',
    'invalid_credentials': 'Invalid email or password',
    'registration_success': 'Registration successful!',
    'login_success': 'Login successful!',
    'please_accept_terms': 'Please accept the Terms and Conditions',
    
    // Event Status
    'live': 'LIVE',
    'coming_soon': 'COMING SOON',
    'ended': 'ENDED',
    
    // Event Messages
    'no_upcoming_events': 'No upcoming events found.',
    'no_past_events': 'No past events found.',
    'no_current_events': 'No current events available.',
    'no_ongoing_upcoming_events': 'No ongoing or upcoming events found.',
    'error_loading_events': 'Error loading events',
    'error_loading_upcoming_events': '⚠️ Error loading upcoming events',
    'error_loading_past_events': '⚠️ Error loading past events',
    'no_upcoming_events_available': 'No upcoming events available.',
    'no_past_events_available': 'No past events available.',
    
    // Event Details
    'untitled_event': 'Untitled Event',
    'unnamed_event': 'Unnamed Event',
    'unknown_host': 'Unknown Host',
    'unknown_location': 'Unknown Location',
    'unknown_date': 'Unknown Date',
    
    // Navigation Buttons (English base text)
    'current_event': 'Current Event',
    'upcoming_program': 'Upcoming Program',  
    'past_time': 'Past Events',
    
    // Translation Cache
    'clear_translation_cache': 'Clear Translation Cache',
    'refresh_translations': 'Refresh Translations',
    'changing_language': 'Changing language...',
    'refreshing_translations': 'Refreshing translations...',
    
    // Demo
    'multilingual_demo': 'Multilingual Demo',
  };

  final Map<String, Map<String, String>> _translationCache = {};
  String _currentLanguage = defaultLanguage;
  bool _isInitialized = false;
  bool _isPreloading = false;
  double _preloadProgress = 0.0;

  String get currentLanguage => _currentLanguage;
  bool get isInitialized => _isInitialized;
  bool get isPreloading => _isPreloading;
  double get preloadProgress => _preloadProgress;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _translationCache['en'] = Map<String, String>.from(_baseTexts);
    
    // Initialize Marathi cache with manually provided names and navigation buttons
    _translationCache['mr'] = {
      'rohit_pawar_mr': 'रोहित पवार',
      'suresh_patil_mr': 'सुरेश पाटील',
      'vikram_jadhav_mr': 'विक्रम जाधव',
      'nitin_gaikwad_mr': 'नितीन गायकवाड',
      'rajesh_shinde_mr': 'राजेश शिंदे',
      // Navigation buttons in Marathi (from screenshots)
      'current_event': 'वर्तमान घटना',
      'upcoming_program': 'आगामी कार्यक्रम',
      'past_time': 'भूतकाळातील',
    };
    
    _isInitialized = true;
    
    debugPrint('Translation service initialized with ${_baseTexts.length} base texts');
  }

  Future<void> loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('app_language') ?? defaultLanguage;
      
      if (supportedLanguages.contains(savedLanguage)) {
        _currentLanguage = savedLanguage;
      }
      
      final cachedTranslations = prefs.getString('translations_$_currentLanguage');
      if (cachedTranslations != null) {
        final Map<String, dynamic> decoded = json.decode(cachedTranslations);
        _translationCache[_currentLanguage] = decoded.cast<String, String>();
        debugPrint('Loaded ${_translationCache[_currentLanguage]?.length ?? 0} cached translations for $_currentLanguage');
      }
    } catch (e) {
      debugPrint('Error loading language preference: $e');
    }
  }

  Future<String> _translateWithApi(String text, String targetLang) async {
    try {
      final apiUrl = _apiUrls[targetLang] ?? _apiUrls['mr']!;
      final response = await http.post(
        Uri.parse('$apiUrl/translate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'source': 'en',
          'target': targetLang,
          'format': 'text',
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['translatedText'] ?? text;
      } else {
        debugPrint('Translation API error: ${response.statusCode}');
        return text;
      }
    } catch (e) {
      debugPrint('Translation error: $e');
      return text;
    }
  }

  String translate(String key) {
    if (_currentLanguage == 'en') {
      return _baseTexts[key] ?? key;
    }
    
    if (_translationCache[_currentLanguage]?.containsKey(key) == true) {
      return _translationCache[_currentLanguage]![key]!;
    }
    
    return _baseTexts[key] ?? key;
  }

  Future<String> translateAsync(String key) async {
    if (_currentLanguage == 'en') {
      return _baseTexts[key] ?? key;
    }
    
    if (_translationCache[_currentLanguage]?.containsKey(key) == true) {
      return _translationCache[_currentLanguage]![key]!;
    }
    
    final baseText = _baseTexts[key];
    if (baseText == null) return key;
    
    final translated = await _translateWithApi(baseText, _currentLanguage);
    
    _translationCache[_currentLanguage] ??= {};
    _translationCache[_currentLanguage]![key] = translated;
    
    _saveCacheToPrefs(_currentLanguage);
    
    return translated;
  }

  Future<void> preloadLanguage(String language, {bool forceRefresh = false}) async {
    if (!supportedLanguages.contains(language)) return;
    if (language == 'en') return;
    
    if (!forceRefresh && _translationCache[language]?.isNotEmpty == true) {
      debugPrint('Translations for $language already cached');
      return;
    }
    
    _isPreloading = true;
    _preloadProgress = 0.0;
    notifyListeners();
    
    debugPrint('Preloading translations for $language from API...');
    
    _translationCache[language] = {};
    int count = 0;
    final total = _baseTexts.length;
    
    for (var entry in _baseTexts.entries) {
      final translated = await _translateWithApi(entry.value, language);
      _translationCache[language]![entry.key] = translated;
      count++;
      
      _preloadProgress = count / total;
      
      if (count % 10 == 0) {
        debugPrint('Preloaded $count/$total translations for $language');
        notifyListeners();
      }
    }
    
    await _saveCacheToPrefs(language);
    debugPrint('Preloaded $count/$total translations for $language');
    
    _isPreloading = false;
    _preloadProgress = 1.0;
    notifyListeners();
  }

  Future<void> _saveCacheToPrefs(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = json.encode(_translationCache[language]);
      await prefs.setString('translations_$language', cacheData);
    } catch (e) {
      debugPrint('Error saving cache: $e');
    }
  }

  Future<void> changeLanguage(String language) async {
    if (!supportedLanguages.contains(language)) return;
    if (_currentLanguage == language) return;
    
    _currentLanguage = language;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', language);
    
    notifyListeners();
    
    if (language != 'en' && _translationCache[language]?.isEmpty != false) {
      preloadLanguage(language, forceRefresh: false);
    }
  }

  Future<void> clearCache() async {
    debugPrint('Clearing translation cache...');
    _translationCache.clear();
    _translationCache['en'] = Map<String, String>.from(_baseTexts);
    
    final prefs = await SharedPreferences.getInstance();
    for (var lang in supportedLanguages) {
      await prefs.remove('translations_$lang');
    }
    
    notifyListeners();
  }
}
