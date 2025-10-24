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
  
  static const String _apiUrl = 'https://evoblack-libretranslate-marathi.hf.space/translate';

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
    'bailgada_host_dashboard': 'Bailgada Host Dashboard',
    'create_event': 'Create Event',
    'add_event': 'Add Event',
    'applications': 'Applications',
    'payments': 'Payments',
    'failed_to_change_language': 'Failed to change language',
    'translation_debug': 'Translation Debug',
    'total_events': 'Total Events',
    'total_events_hosted': 'Total Events Hosted',
    'total_revenue': 'Total Revenue',
    'active_participants': 'Active Participants',
    'participants': 'Participants',
    'event_analytics': 'Event Analytics',
    'pending_approvals': 'Pending Approvals',
    'upcoming_races': 'Upcoming Races',
    'next_big_event': 'Next Big Event',
    'recent_activities': 'Recent Activities',
    
    // Carousel
    'carousel_title_1': 'Welcome to BullCart Race',
    'carousel_subtitle_1': 'Feel the speed, embrace the tradition',
    'carousel_title_2': 'Register Your Team',
    'carousel_subtitle_2': 'Show your strength on the track',
    'carousel_title_3': 'Cheer Live Action',
    'carousel_subtitle_3': 'Support your favorite riders',
    
    // Common
    'welcome': 'Welcome',
    'loading': 'Loading',
    'error': 'Error',
    'success': 'Success',
    'no_data': 'No data available',
    'try_again': 'Try Again',
    'language': 'Language',
    'select_language': 'Select Language',
    'ready_to_join': 'Ready to Join the Race?',
    'register_now': 'Register Now',
    'register_now_message': 'Register now to confirm your participation in this event!',
    'registration_coming_soon': 'Registration feature coming soon!',
    
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
    'email_address': 'Email Address',
    'password': 'Password',
    'confirm_password': 'Confirm Password',
    'phone': 'Phone Number',
    'phone_number': 'Phone Number',
    'full_name': 'Full Name',
    'remember_me': 'Remember Me',
    'forgot_password': 'Forgot Password?',
    'dont_have_account': "Don't have an account?",
    'already_have_account': 'Already have an account?',
    'create_account': 'Create Account',
    'register': 'Register',
    'accept_terms': 'I accept the Terms and Conditions',
    'agree_terms': 'I agree to the Terms & Conditions',
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
    'user_registered_successfully': 'User registered successfully!',
    'login_success': 'Login successful!',
    'please_accept_terms': 'Please accept the Terms and Conditions',
    'sign_in_to_continue': 'Sign in to continue',
    'join_bailgada_race': 'Join BailGada Race today',
    'bailgada_race': 'BailGada Race',
    'reset_password': 'Reset Password',
    'forgot_password_title': 'Forgot Password?',
    'reset_instructions': "Enter your registered email and we'll send you reset instructions.",
    'back_to_sign_in': 'Back to Sign In',
    'please_enter_name': 'Please enter your name',
    'please_enter_email': 'Please enter your email',
    'please_enter_valid_email': 'Please enter a valid email',
    'please_enter_phone': 'Please enter your phone number',
    'please_enter_valid_phone': 'Please enter a valid 10-digit number',
    'please_enter_password': 'Please enter your password',
    'please_confirm_password': 'Please confirm your password',
    'password_min_6': 'Password must be at least 6 characters',
    
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
    
    // Event Details
    'untitled_event': 'Untitled Event',
    'unnamed_event': 'Unnamed Event',
    'unknown_host': 'Unknown Host',
    'unknown_location': 'Unknown Location',
    'unknown_date': 'Unknown Date',
    
    // Navigation Buttons (English base text)
    'current_event_nav': 'Current Event',
    'upcoming_program': 'Upcoming Program',  
    'past_time': 'Past Events',
    
    // Translation Cache
    'clear_translation_cache': 'Clear Translation Cache',
    'refresh_translations': 'Refresh Translations',
    'changing_language': 'Changing language...',
    'refreshing_translations': 'Refreshing translations...',
    
    // Demo
    'multilingual_demo': 'Multilingual Demo',
    
    // Profile Screen Additional
    'confirm_logout': 'Confirm Logout',
    'logout_confirmation': 'Are you sure you want to log out?',
    
    // My Bail OX Screen
    'my_bail_ox': 'My Bail (OX)',
    'no_ox_added_yet': 'No OX added yet',
    'unnamed_ox': 'Unnamed OX',
    'single': 'Single',
    'pair': 'Pair',
    'add_ox': 'Add OX',
    'ox_details': 'OX Details',
    'ox_pair_details': 'OX Pair Details',
    'ox_name': 'OX Name',
    'first_ox_name': 'First OX Name',
    'second_ox_name': 'Second OX Name',
    'ox_photo': 'OX Photo',
    'first_ox_photo': 'First OX Photo',
    'second_ox_photo': 'Second OX Photo',
    'select_type': 'Select Type',
    'save_ox': 'Save OX',
    'enter_ox_name': 'Enter OX name',
    'enter_first_ox_name': 'Enter first OX name',
    'enter_second_ox_name': 'Enter second OX name',
    'please_add_ox_photo': 'Please add OX photo',
    'please_add_both_ox_photos': 'Please add both OX photos',
    'tap_to_add': 'Tap to add',
    'bail_type': 'Bail Type',
    'adat_bail': 'Adat bail',
    'dusa_bail': 'Dusa bail',
    'chosa_bail': 'Chosa bail',
    'bail_details': 'Bail Details (Optional)',
    'bail_details_hint': 'Enter details about your bail...',
    'bail_achievements': 'Bail Achievements (Optional)',
    'bail_achievements_hint': 'Enter achievements, awards, wins...',
    
    // Event Host Page
    'bailgada_race_championship': 'Bailgada Race - Championship 2025',
    'live_from_location': 'Live from Kundapura, Karnataka',
    'rounds': 'Rounds',
    'all': 'ALL',
    'race_slots': 'Race Slots',
    'slots_yet_to_be_declared': 'Slots Yet to be Declared',
    'stay_tuned_next_round': 'Stay tuned for the next exciting round!',
    'no_participants_available': 'No participants available for this slot.',
    'track': 'Track',
    
    // Racer Details
    'racer': 'Racer',
    'bull': 'Bull',
    'village': 'Village',
    'experience': 'Experience',
    'previous_wins': 'Previous Wins',
    'races': 'races',
    
    // Host Dashboard Additional
    'welcome_back_host': 'Welcome back, Shivaji! Manage your races, participants & sponsors efficiently.',
    'kolhapur_bull_power': 'Kolhapur Bull Power Challenge',
    'new_event_created': 'New Event Created: Pune Championship 2025',
    'hours_ago': 'hours ago',
    'new_participant_registered': 'New Participant Registered',
    'sponsor_added': 'Sponsor Added: Maharashtra Tourism',
    'day_ago': 'day ago',
    'days_ago': 'days ago',
    'event_approved': 'Event Approved: Sangli Rural Fest',
    'bulls_glory_quote': '"The power of your bulls defines the glory of your race."',
    'bailgada_team': '- Bailgada Sharyat Team',
    
    // Bottom Nav
    
    // Event Creation Page
    'create_new_event': 'Create New Event',
    'event_information': 'Event Information',
    'event_name': 'Event Name',
    'event_name_required': 'Event Name *',
    'enter_event_name': 'Enter event name',
    'event_intro': 'Event Intro (Optional)',
    'event_description': 'Brief description of the event',
    'upload_video': 'Upload Video',
    'youtube_url': 'YouTube URL',
    'paste_youtube_link': 'Paste YouTube link',
    'video_selected': 'Video selected',
    'upload_banner': 'Upload Banner',
    'location_and_date': 'Location & Date',
    'event_location': 'Event Location',
    'event_location_required': 'Event Location *',
    'enter_location': 'Enter location',
    'event_date': 'Event Date',
    'event_date_required': 'Event Date *',
    'select_date': 'Select date',
    'event_time': 'Event Time',
    'event_time_required': 'Event Time *',
    'select_time': 'Select time',
    'race_details': 'Race Details',
    'total_participants': 'Total Number of Participants',
    'total_participants_required': 'Total Number of Participants *',
    'enter_number': 'Enter number',
    'number_of_tracks': 'Number of Tracks',
    'number_of_tracks_required': 'Number of Tracks *',
    'enter_number_of_tracks': 'Enter number of tracks',
    'documents_and_fees': 'Documents & Fees',
    'approval_certificate': 'Approval Certificate',
    'approval_certificate_required': 'Approval Certificate *',
    'selected': 'Selected',
    'registration_fees': 'Registration Fees (₹)',
    'registration_fees_required': 'Registration Fees (₹) *',
    'enter_amount': 'Enter amount',
    'sponsors': 'Sponsors',
    'sponsor': 'Sponsor',
    'add_sponsor': 'Add Sponsor',
    'sponsor_name': 'Sponsor Name',
    'sponsor_photo': 'Sponsor Photo',
    'sponsor_intro': 'Sponsor Intro',
    'save_draft': 'Save Draft',
    'submit_for_approval': 'Submit for Approval',
    'draft_saved': 'Draft Saved!',
    'event_created_success': '✅ Event successfully created!',
    'failed_to_save_event': '❌ Failed to save event',
    'required': 'Required',
    'tap_to_upload': 'Tap to upload',
    
    // Additional Static UI Elements
    'you_host': 'You (Host)',
    'status': 'Status',
    'upcoming': 'Upcoming',
    'description': 'Description',
    'no_description_available': 'No description available',
    'location_not_specified': 'Location not specified',
    'event_registration': 'Event Registration',
    'please_fill_all_fields': 'Please fill all fields',
    'form_submitted_successfully': 'Form Submitted Successfully!',
    'thank_you_for_registering': 'Thank you for registering. Tap below to view your submission preview.',
    'proceed_to_payment': 'Proceed to Payment',
    'view_preview': 'View Preview',
    'fill_participant_details': 'Fill Participant Details',
    'results_screen_coming_soon': 'Results screen coming soon!',
    'rehost_feature_coming_soon': 'Re-Host feature coming soon!',
    'my_races_clicked': 'My Races clicked!',
    'view_results': 'View Results',
    'date': 'Date',
    'time': 'Time',
    'venue': 'Venue',
    'organizer': 'Organizer',
    'contact': 'Contact',
    'details': 'Details',
    'view_details': 'View Details',
    'back': 'Back',
    'next': 'Next',
    'previous': 'Previous',
    'close': 'Close',
    'ok': 'OK',
    'yes': 'Yes',
    'no': 'No',
    'confirm': 'Confirm',
    'apply': 'Apply',
    'reset': 'Reset',
    'filter': 'Filter',
    'sort': 'Sort',
    'share': 'Share',
    'download': 'Download',
    'upload': 'Upload',
    'refresh': 'Refresh',
    'retry': 'Retry',
    'continue': 'Continue',
    'skip': 'Skip',
    'done': 'Done',
    'finish': 'Finish',
    'start': 'Start',
    'stop': 'Stop',
    'pause': 'Pause',
    'resume': 'Resume',
    'play': 'Play',
    'record': 'Record',
    'send': 'Send',
    'receive': 'Receive',
    'add': 'Add',
    'remove': 'Remove',
    'clear': 'Clear',
    'select': 'Select',
    'deselect': 'Deselect',
    'select_all': 'Select All',
    'deselect_all': 'Deselect All',
    'enable': 'Enable',
    'disable': 'Disable',
    'show': 'Show',
    'hide': 'Hide',
    'expand': 'Expand',
    'collapse': 'Collapse',
    'more': 'More',
    'less': 'Less',
    'view_more': 'View More',
    'view_less': 'View Less',
    'see_all': 'See All',
    'show_all': 'Show All',
    'hide_all': 'Hide All',
    'load_more': 'Load More',
    'no_results': 'No Results',
    'no_items': 'No Items',
    'empty': 'Empty',
    'not_available': 'Not Available',
    'coming_soon_feature': 'Coming Soon',
    'under_development': 'Under Development',
    'maintenance': 'Maintenance',
    'offline': 'Offline',
    'online': 'Online',
    'connected': 'Connected',
    'disconnected': 'Disconnected',
    'syncing': 'Syncing',
    'synced': 'Synced',
    'failed': 'Failed',
    'completed': 'Completed',
    'pending': 'Pending',
    'processing': 'Processing',
    'approved': 'Approved',
    'rejected': 'Rejected',
    'cancelled': 'Cancelled',
    'active': 'Active',
    'inactive': 'Inactive',
    'enabled': 'Enabled',
    'disabled': 'Disabled',
    'available': 'Available',
    'unavailable': 'Unavailable',
    'optional': 'Optional',
    'recommended': 'Recommended',
    'new': 'New',
    'old': 'Old',
    'latest': 'Latest',
    'oldest': 'Oldest',
    'popular': 'Popular',
    'trending': 'Trending',
    'featured': 'Featured',
    'none': 'None',
    'other': 'Other',
    'custom': 'Custom',
    'default': 'Default',
    'auto': 'Auto',
    'manual': 'Manual',
    'automatic': 'Automatic',
  };

  final Map<String, Map<String, String>> _translationCache = {};
  String _currentLanguage = defaultLanguage;
  bool _isInitialized = false;
  bool _isPreloading = false;
  double _preloadProgress = 0.0;
  bool _apiEnabled = true;
  int _apiFailureCount = 0;
  static const int _maxApiFailures = 50;
  DateTime? _lastApiFailure;
  
  // Track pending translations to avoid duplicates
  final Map<String, Future<String>> _pendingTranslations = {};
  
  // Request queue to prevent overwhelming the API
  static const int _maxConcurrentRequests = 2;
  int _activeRequests = 0;

  String get currentLanguage => _currentLanguage;
  bool get isInitialized => _isInitialized;
  bool get isPreloading => _isPreloading;
  double get preloadProgress => _preloadProgress;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _translationCache['en'] = Map<String, String>.from(_baseTexts);
    
    // Initialize Marathi cache with comprehensive manual translations
    _translationCache['mr'] = {
      // Navigation
      'home': 'होम',
      'profile': 'प्रोफाइल',
      'settings': 'सेटिंग्ज',
      'language': 'भाषा',
      'logout': 'लॉगआउट',
      
      // Profile Screen
      'edit_profile': 'प्रोफाइल एडिट करा',
      'change_password': 'पासवर्ड बदला',
      'notifications': 'नोटिफिकेशन',
      'privacy': 'प्रायव्हसी',
      'help': 'हेल्प',
      'about': 'अबाउट',
      'my_bail_ox': 'माझा बैल',
      'no_ox_added_yet': 'अद्याप कोणताही बैल जोडलेला नाही',
      'unnamed_ox': 'अनामित बैल',
      'single': 'सिंगल',
      'pair': 'पेअर',
      'add_ox': 'बैल ॲड करा',
      'ox_details': 'बैलाचे तपशील',
      'ox_pair_details': 'बैल जोडीचे तपशील',
      'ox_name': 'बैलाचे नाव',
      'first_ox_name': 'पहिल्या बैलाचे नाव',
      'second_ox_name': 'दुसऱ्या बैलाचे नाव',
      'ox_photo': 'बैलाचा फोटो',
      'first_ox_photo': 'पहिल्या बैलाचा फोटो',
      'second_ox_photo': 'दुसऱ्या बैलाचा फोटो',
      'select_type': 'प्रकार निवडा',
      'save_ox': 'बैल जतन करा',
      'enter_ox_name': 'बैलाचे नाव प्रविष्ट करा',
      'enter_first_ox_name': 'पहिल्या बैलाचे नाव प्रविष्ट करा',
      'enter_second_ox_name': 'दुसऱ्या बैलाचे नाव प्रविष्ट करा',
      'please_add_ox_photo': 'कृपया बैलाचा फोटो जोडा',
      'please_add_both_ox_photos': 'कृपया दोन्ही बैलांचे फोटो जोडा',
      'tap_to_add': 'जोडण्यासाठी टॅप करा',
      'bail_type': 'बैलाचा प्रकार',
      'adat_bail': 'अडत बैल',
      'dusa_bail': 'दुसा बैल',
      'chosa_bail': 'चोसा बैल',
      'bail_details': 'बैलाची माहिती (Optional)',
      'bail_details_hint': 'तुमच्या बैलाबद्दल माहिती प्रविष्ट करा...',
      'bail_achievements': 'बैलाची कामगिरी (Optional)',
      'bail_achievements_hint': 'कामगिरी, पुरस्कार, विजय प्रविष्ट करा...',
      'host': 'होस्ट',
      'confirm_logout': 'लॉगआउट कन्फर्म करा',
      'logout_confirmation': 'तुम्ही खरोखर लॉगआउट करू इच्छिता?',
      'cancel': 'कॅन्सल',
      
      // Events
      'events': 'इव्हेंट्स',
      'current_events': 'चालू इव्हेंट्स',
      'upcoming_events': 'आगामी इव्हेंट्स',
      'past_events': 'मागील इव्हेंट्स',
      'live': 'लाइव्ह',
      'coming_soon': 'लवकरच',
      'ended': 'संपले',
      
      // Navigation buttons
      'current_event_nav': 'चालू इव्हेंट',
      'upcoming_program': 'आगामी प्रोग्राम',
      'past_time': 'मागील इव्हेंट्स',
      
      // Racer names
      'rohit_pawar': 'रोहित पवार',
      'suresh_patil': 'सुरेश पाटील',
      'vikram_jadhav': 'विक्रम जाधव',
      'nitin_gaikwad': 'नितीन गायकवाड',
      'rajesh_shinde': 'राजेश शिंदे',
      
      // Common
      'loading': 'लोडिंग',
      'error': 'एरर',
      'success': 'यशस्वी',
      'save': 'सेव्ह',
      'delete': 'डिलीट',
      'edit': 'एडिट',
      'create': 'क्रिएट',
      'update': 'अपडेट',
      'search': 'सर्च',
      'select_language': 'भाषा निवडा',
      'changing_language': 'भाषा बदलत आहे...',
      
      // Leaderboard
      'leaderboard': 'लीडरबोर्ड',
      'top_racers': 'टॉप रेसर्स',
      'points': 'पॉइंट्स',
      'view_full_leaderboard': 'लीडरबोर्ड पहा',
      
      // Carousel
      'carousel_title_1': 'बुलकार्ट रेसमध्ये आपले स्वागत',
      'carousel_subtitle_1': 'वेग अनुभवा, परंपरा स्वीकारा',
      'carousel_title_2': 'तुमची टीम नोंदवा',
      'carousel_subtitle_2': 'ट्रॅकवर तुमची शक्ती दाखवा',
      'carousel_title_3': 'थेट कृती पहा',
      'carousel_subtitle_3': 'तुमच्या आवडत्या रायडर्सना पाठिंबा द्या',
      
      // Event Messages
      'no_upcoming_events': 'आगामी इव्हेंट्स आढळले नाहीत.',
      'no_past_events': 'मागील इव्हेंट्स आढळले नाहीत.',
      'no_current_events': 'चालू इव्हेंट्स उपलब्ध नाहीत.',
      'no_ongoing_upcoming_events': 'चालू किंवा आगामी इव्हेंट्स आढळले नाहीत.',
      'error_loading_events': 'इव्हेंट्स लोड करताना एरर',
      'error_loading_upcoming_events': '⚠️ आगामी इव्हेंट्स लोड करताना एरर',
      'error_loading_past_events': '⚠️ मागील इव्हेंट्स लोड करताना एरर',
      
      // Host Dashboard
      'host_dashboard': 'होस्ट डॅशबोर्ड',
      'bailgada_host_dashboard': 'बैलगाडा होस्ट डॅशबोर्ड',
      'add_event': 'इव्हेंट ॲड करा',
      'total_events': 'एकूण इव्हेंट्स',
      'pending_approvals': 'पेंडिंग अप्रूव्हल्स',
      'participants': 'पार्टिसिपंट्स',
      'upcoming_races': 'आगामी रेसेस',
      'next_big_event': 'पुढील मोठा इव्हेंट',
      'recent_activities': 'अलीकडील ॲक्टिव्हिटीज',
      
      // Event Details
      'ready_to_join': 'रेसमध्ये सामील होण्यास तयार आहात?',
      'register_now': 'आता रजिस्टर करा',
      'register_now_message': 'या इव्हेंटमध्ये तुमचा सहभाग कन्फर्म करण्यासाठी आता रजिस्टर करा!',
      'registration_coming_soon': 'रजिस्ट्रेशन फीचर लवकरच येत आहे!',
      'no_data': 'डेटा उपलब्ध नाही',
      'unknown_location': 'लोकेशन माहित नाही',
      'unknown_date': 'तारीख माहित नाही',
      'untitled_event': 'अनटायटल्ड इव्हेंट',
      'unnamed_event': 'अनेम्ड इव्हेंट',
      
      // Authentication Marathi
      'sign_in': 'साइन इन',
      'sign_up': 'साइन अप',
      'email': 'ईमेल',
      'email_address': 'ईमेल ॲड्रेस',
      'password': 'पासवर्ड',
      'confirm_password': 'पासवर्ड कन्फर्म करा',
      'phone_number': 'फोन नंबर',
      'full_name': 'पूर्ण नाव',
      'remember_me': 'मला लक्षात ठेवा',
      'forgot_password': 'पासवर्ड विसरलात?',
      'dont_have_account': 'अकाउंट नाही?',
      'already_have_account': 'आधीच अकाउंट आहे?',
      'create_account': 'अकाउंट क्रिएट करा',
      'agree_terms': 'मी अटी स्वीकारतो',
      'sign_in_to_continue': 'सुरू ठेवण्यासाठी साइन इन करा',
      'join_bailgada_race': 'आज बैलगाडा रेसमध्ये सामील व्हा',
      'bailgada_race': 'बैलगाडा रेस',
      'reset_password': 'पासवर्ड रीसेट करा',
      'forgot_password_title': 'पासवर्ड विसरलात?',
      'reset_instructions': 'तुमचा रजिस्टर्ड ईमेल एंटर करा आणि आम्ही तुम्हाला रीसेट इन्स्ट्रक्शन्स पाठवू.',
      'back_to_sign_in': 'साइन इन वर परत या',
      'please_enter_name': 'कृपया तुमचे नाव एंटर करा',
      'please_enter_email': 'कृपया तुमचा ईमेल एंटर करा',
      'please_enter_valid_email': 'कृपया वैध ईमेल एंटर करा',
      'please_enter_phone': 'कृपया तुमचा फोन नंबर एंटर करा',
      'please_enter_valid_phone': 'कृपया वैध 10-डिजिट नंबर एंटर करा',
      'please_enter_password': 'कृपया तुमचा पासवर्ड एंटर करा',
      'please_confirm_password': 'कृपया तुमच्या पासवर्डची कन्फर्म करा',
      'password_min_6': 'पासवर्ड किमान 6 कॅरेक्टर्सचा असावा',
      'passwords_dont_match': 'पासवर्ड मॅच होत नाहीत',
      'invalid_credentials': 'इनव्हॅलिड ईमेल किंवा पासवर्ड',
      'user_registered_successfully': 'यूजर यशस्वीरित्या रजिस्टर झाला!',
      'please_accept_terms': 'कृपया टर्म्स अँड कंडिशन्स ॲक्सेप्ट करा',
      'ride_the_speed': 'वेगाचा अनुभव घ्या, ट्रॅकवर राज्य करा',
      
      // Host Dashboard Additional
      'welcome_back_host': 'वेलकम बॅक, शिवाजी! तुमच्या रेसेस, पार्टिसिपंट्स आणि स्पॉन्सर्सचे कार्यक्षमतेने मॅनेज करा.',
      'kolhapur_bull_power': 'कोल्हापूर बुल पॉवर चॅलेंज',
      'new_event_created': 'नवीन इव्हेंट क्रिएट केला: पुणे चॅम्पियनशिप 2025',
      'hours_ago': 'तासांपूर्वी',
      'new_participant_registered': 'नवीन पार्टिसिपंट रजिस्टर झाला',
      'sponsor_added': 'स्पॉन्सर ॲड केला: महाराष्ट्र टुरिझम',
      'day_ago': 'दिवसापूर्वी',
      'days_ago': 'दिवसांपूर्वी',
      'event_approved': 'इव्हेंट अप्रूव्ह झाला: सांगली रुरल फेस्ट',
      'bulls_glory_quote': '"तुमच्या बैलांची पॉवर तुमच्या रेसचे ग्लोरी ठरवते."',
      'bailgada_team': '- बैलगाडा शर्यत टीम',
      
      // Event Creation Page
      'create_new_event': 'नवीन इव्हेंट क्रिएट करा',
      'event_information': 'इव्हेंट इन्फॉर्मेशन',
      'event_name': 'इव्हेंटचे नाव',
      'event_name_required': 'इव्हेंटचे नाव *',
      'enter_event_name': 'इव्हेंटचे नाव एंटर करा',
      'event_intro': 'इव्हेंट इंट्रो (ऑप्शनल)',
      'event_description': 'इव्हेंटचे ब्रीफ डिस्क्रिप्शन',
      'upload_video': 'व्हिडिओ अपलोड करा',
      'youtube_url': 'YouTube URL',
      'paste_youtube_link': 'YouTube लिंक पेस्ट करा',
      'video_selected': 'व्हिडिओ सिलेक्ट केला',
      'upload_banner': 'बॅनर अपलोड करा',
      'location_and_date': 'लोकेशन आणि डेट',
      'event_location': 'इव्हेंट लोकेशन',
      'event_location_required': 'इव्हेंट लोकेशन *',
      'enter_location': 'लोकेशन एंटर करा',
      'event_date': 'इव्हेंट डेट',
      'event_date_required': 'इव्हेंट डेट *',
      'select_date': 'डेट सिलेक्ट करा',
      'event_time': 'इव्हेंट टाइम',
      'event_time_required': 'इव्हेंट टाइम *',
      'select_time': 'टाइम सिलेक्ट करा',
      'race_details': 'रेस डिटेल्स',
      'total_participants': 'एकूण पार्टिसिपंट्सची संख्या',
      'total_participants_required': 'एकूण पार्टिसिपंट्सची संख्या *',
      'enter_number': 'नंबर एंटर करा',
      'number_of_tracks': 'ट्रॅक्सची संख्या',
      'number_of_tracks_required': 'ट्रॅक्सची संख्या *',
      'enter_number_of_tracks': 'ट्रॅक्सची संख्या एंटर करा',
      'documents_and_fees': 'डॉक्युमेंट्स आणि फीस',
      'approval_certificate': 'अप्रूव्हल सर्टिफिकेट',
      'approval_certificate_required': 'अप्रूव्हल सर्टिफिकेट *',
      'selected': 'सिलेक्ट केले',
      'registration_fees': 'रजिस्ट्रेशन फीस (₹)',
      'registration_fees_required': 'रजिस्ट्रेशन फीस (₹) *',
      'enter_amount': 'अमाउंट एंटर करा',
      'sponsors': 'स्पॉन्सर्स',
      'sponsor': 'स्पॉन्सर',
      'add_sponsor': 'स्पॉन्सर ॲड करा',
      'sponsor_name': 'स्पॉन्सरचे नाव',
      'sponsor_photo': 'स्पॉन्सरचा फोटो',
      'sponsor_intro': 'स्पॉन्सर इंट्रो',
      'save_draft': 'ड्राफ्ट सेव्ह करा',
      'submit_for_approval': 'अप्रूव्हलसाठी सबमिट करा',
      'draft_saved': 'ड्राफ्ट सेव्ह झाला!',
      'event_created_success': '✅ इव्हेंट यशस्वीरित्या क्रिएट झाला!',
      'failed_to_save_event': '❌ इव्हेंट सेव्ह करण्यात फेल',
      'required': 'रिक्वायर्ड',
      'tap_to_upload': 'अपलोड करण्यासाठी टॅप करा',
      
      // Additional Static UI Elements
      'you_host': 'तुम्ही (होस्ट)',
      'unknown_host': 'अननोन होस्ट',
      'status': 'स्टेटस',
      'upcoming': 'आगामी',
      'description': 'डिस्क्रिप्शन',
      'date': 'डेट',
      'time': 'टाइम',
      'venue': 'व्हेन्यू',
      'organizer': 'ऑर्गनायझर',
      'contact': 'कॉन्टॅक्ट',
      'details': 'डिटेल्स',
      'view_details': 'डिटेल्स पहा',
      'back': 'बॅक',
      'next': 'नेक्स्ट',
      'previous': 'प्रिव्हियस',
      'close': 'क्लोज',
      'ok': 'ओके',
      'yes': 'होय',
      'no': 'नाही',
      'confirm': 'कन्फर्म',
      'apply': 'अप्लाय',
      'reset': 'रीसेट',
      'filter': 'फिल्टर',
      'sort': 'सॉर्ट',
      'share': 'शेअर',
      'download': 'डाउनलोड',
      'upload': 'अपलोड',
      'refresh': 'रिफ्रेश',
      'retry': 'रिट्राय',
      'continue': 'कंटिन्यू',
      'skip': 'स्किप',
      'done': 'डन',
      'finish': 'फिनिश',
      'start': 'स्टार्ट',
      'stop': 'स्टॉप',
      'pause': 'पॉज',
      'resume': 'रिज्यूम',
      'play': 'प्ले',
      'record': 'रेकॉर्ड',
      'send': 'सेंड',
      'receive': 'रिसीव्ह',
      'add': 'ॲड',
      'remove': 'रिमूव्ह',
      'clear': 'क्लिअर',
      'select': 'सिलेक्ट',
      'deselect': 'डिसिलेक्ट',
      'select_all': 'सर्व सिलेक्ट',
      'deselect_all': 'सर्व डिसिलेक्ट',
      'enable': 'इनेबल',
      'disable': 'डिसेबल',
      'show': 'शो',
      'hide': 'हाइड',
      'expand': 'एक्सपँड',
      'collapse': 'कोलॅप्स',
      'more': 'मोअर',
      'less': 'लेस',
      'view_more': 'मोअर पहा',
      'view_less': 'लेस पहा',
      'see_all': 'सर्व पहा',
      'show_all': 'सर्व शो',
      'hide_all': 'सर्व हाइड',
      'load_more': 'मोअर लोड',
      'no_results': 'रिझल्ट्स नाहीत',
      'no_items': 'आयटम्स नाहीत',
      'empty': 'एम्प्टी',
      'not_available': 'अवेलेबल नाही',
      'coming_soon_feature': 'लवकरच येत आहे',
      'under_development': 'डेव्हलपमेंट अंडर',
      'maintenance': 'मेंटेनन्स',
      'offline': 'ऑफलाइन',
      'online': 'ऑनलाइन',
      'connected': 'कनेक्टेड',
      'disconnected': 'डिस्कनेक्टेड',
      'syncing': 'सिंकिंग',
      'synced': 'सिंक्ड',
      'failed': 'फेल',
      'completed': 'कम्प्लीट',
      'pending': 'पेंडिंग',
      'processing': 'प्रोसेसिंग',
      'approved': 'अप्रूव्ह',
      'rejected': 'रिजेक्ट',
      'cancelled': 'कॅन्सल',
      'active': 'ॲक्टिव्ह',
      'inactive': 'इनॲक्टिव्ह',
      'enabled': 'इनेबल्ड',
      'disabled': 'डिसेबल्ड',
      'available': 'अवेलेबल',
      'unavailable': 'अनअवेलेबल',
      'optional': 'ऑप्शनल',
      'recommended': 'रेकमेंडेड',
      'new': 'न्यू',
      'old': 'ओल्ड',
      'latest': 'लेटेस्ट',
      'oldest': 'ओल्डेस्ट',
      'popular': 'पॉप्युलर',
      'trending': 'ट्रेंडिंग',
      'featured': 'फीचर्ड',
      'all': 'ऑल',
      'none': 'नन',
      'other': 'अदर',
      'custom': 'कस्टम',
      'default': 'डिफॉल्ट',
      'auto': 'ऑटो',
      'manual': 'मॅन्युअल',
      'automatic': 'ऑटोमॅटिक',
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
    // Check if we should re-enable API
    _checkApiReEnable();
    
    if (!_apiEnabled) {
      debugPrint('⚠️ API disabled, returning original text');
      return text;
    }
    
    // Skip empty or very short text
    if (text.trim().isEmpty || text.length < 2) {
      return text;
    }
    
    // Skip garbage/random text (no vowels, too many numbers, etc.)
    if (!_isValidTextForTranslation(text)) {
      debugPrint('! Skipping invalid text: "$text"');
      return text;
    }
    
    // Wait for available slot
    while (_activeRequests >= _maxConcurrentRequests) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    _activeRequests++;
    
    try {
      // LibreTranslate API format
      final requestBody = {
        'q': text,
        'source': 'en',
        'target': 'mr',  // Marathi language code
        'format': 'text',
        'api_key': '',  // Empty for public API
      };
      
      debugPrint('🌐 API Request ($_activeRequests/$_maxConcurrentRequests): $_apiUrl');
      debugPrint('📤 Request body: ${json.encode(requestBody)}');
      
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: json.encode(requestBody),
      ).timeout(
        const Duration(seconds: 15),  // Increased timeout
        onTimeout: () {
          throw Exception('Translation timeout');
        },
      );
      
      debugPrint('📡 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          
          // LibreTranslate returns 'translatedText' field
          final translatedText = data['translatedText'] as String?;
          
          if (translatedText != null && translatedText.isNotEmpty) {
            // Reset failure tracking on success
            _apiFailureCount = 0;
            _lastApiFailure = null;
            
            debugPrint('✅ Success: "$text" → "$translatedText"');
            
            // Save to cache
            _translationCache[_currentLanguage] ??= {};
            _translationCache[_currentLanguage]!['dynamic_$text'] = translatedText;
            
            return translatedText;
          } else {
            debugPrint('⚠️ Empty translation received');
            return text;
          }
        } catch (e) {
          debugPrint('❌ JSON parse error: $e');
          _handleApiFailure();
          return text;
        }
      } else if (response.statusCode == 400) {
        debugPrint('❌ Bad request - check API format');
        _handleApiFailure();
        return text;
      } else if (response.statusCode == 403) {
        debugPrint('❌ API key required or forbidden');
        _handleApiFailure();
        return text;
      } else if (response.statusCode == 429) {
        debugPrint('❌ Rate limit exceeded');
        _handleApiFailure();
        return text;
      } else {
        debugPrint('❌ API error ${response.statusCode}');
        _handleApiFailure();
        return text;
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException') || e.toString().contains('timeout')) {
        debugPrint('⏱️ API timeout - using original text');
      } else {
        debugPrint('❌ Exception: $e');
      }
      _handleApiFailure();
      return text;
    } finally {
      _activeRequests--;
    }
  }
  
  void _handleApiFailure() {
    _apiFailureCount++;
    _lastApiFailure = DateTime.now();
    
    if (_apiFailureCount >= _maxApiFailures) {
      _apiEnabled = false;
      debugPrint('Translation API disabled after $_maxApiFailures failures');
      debugPrint('You can re-enable it from Settings > Translation Debug > Force Enable API');
    } else {
      debugPrint('API failure count: $_apiFailureCount/$_maxApiFailures');
    }
  }
  
  // Auto re-enable API after some time
  void _checkApiReEnable() {
    if (!_apiEnabled && _lastApiFailure != null) {
      final timeSinceFailure = DateTime.now().difference(_lastApiFailure!);
      if (timeSinceFailure.inMinutes > 5) {
        debugPrint('Auto re-enabling API after 5 minutes');
        _apiEnabled = true;
        _apiFailureCount = 0;
        _lastApiFailure = null;
      }
    }
  }
  
  // Validate if text is worth translating
  bool _isValidTextForTranslation(String text) {
    // Must have at least one vowel
    if (!text.toLowerCase().contains(RegExp(r'[aeiou]'))) {
      return false;
    }
    
    // Skip if mostly numbers
    final digitCount = text.replaceAll(RegExp(r'[^0-9]'), '').length;
    if (digitCount > text.length * 0.5) {
      return false;
    }
    
    // Skip random strings with too many consonants in a row
    if (RegExp(r'[bcdfghjklmnpqrstvwxyz]{7,}', caseSensitive: false).hasMatch(text)) {
      return false;
    }
    
    return true;
  }

  String translate(String key) {
    if (_currentLanguage == 'en') {
      return _baseTexts[key] ?? key;
    }
    
    // Check cache first - this should contain our manual translations
    if (_translationCache[_currentLanguage]?.containsKey(key) == true) {
      return _translationCache[_currentLanguage]![key]!;
    }
    
    // Fallback to base text if no translation found
    return _baseTexts[key] ?? key;
  }

  Future<String> translateAsync(String key) async {
    if (_currentLanguage == 'en') {
      return _baseTexts[key] ?? key;
    }
    
    final baseText = _baseTexts[key];
    if (baseText == null) return key;
    
    // Check if we have a cached translation first (includes manual translations)
    if (_translationCache[_currentLanguage]?.containsKey(key) == true) {
      return _translationCache[_currentLanguage]![key]!;
    }
    
    try {
      // Try API translation with timeout handling
      final translated = await _translateWithApi(baseText, _currentLanguage);
      
      // Cache the result
      _translationCache[_currentLanguage] ??= {};
      _translationCache[_currentLanguage]![key] = translated;
      
      // Save to persistent storage
      _saveCacheToPrefs(_currentLanguage);
      
      // Notify listeners to update UI
      notifyListeners();
      
      return translated;
    } catch (e) {
      debugPrint('❌ translateAsync failed for "$key": $e');
      return translate(key);
    }
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
      try {
        final translated = await _translateWithApi(entry.value, language);
        _translationCache[language]![entry.key] = translated;
      } catch (e) {
        // Use fallback translation on error
        _translationCache[language]![entry.key] = entry.value;
        debugPrint('Failed to translate "${entry.key}", using fallback');
      }
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
    
    // Clear cached translations to force reload with new translations
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('translations_$language');
    
    _currentLanguage = language;
    await prefs.setString('app_language', language);
    
    // Force reinitialize Marathi translations from the base cache
    if (language == 'mr') {
      await initialize(); // This will reload the correct Marathi translations
    }
    
    notifyListeners();
  }

  Future<void> clearCache() async {
    debugPrint('Clearing translation cache...');
    _translationCache.clear();
    _translationCache['en'] = Map<String, String>.from(_baseTexts);
    
    final prefs = await SharedPreferences.getInstance();
    for (var lang in supportedLanguages) {
      await prefs.remove('translations_$lang');
    }
    
    // Re-enable API and reset failure count
    _apiEnabled = true;
    _apiFailureCount = 0;
    _lastApiFailure = null;
    
    notifyListeners();
  }
  
  void enableApi() {
    _apiEnabled = true;
    _apiFailureCount = 0;
    _lastApiFailure = null;
    debugPrint('Translation API re-enabled manually');
    notifyListeners();
  }
  
  void forceEnableApi() {
    _apiEnabled = true;
    _apiFailureCount = 0;
    _lastApiFailure = null;
    debugPrint('Translation API force-enabled, resetting failure count');
    notifyListeners();
  }
  
  bool get isApiEnabled => _apiEnabled;
  
  // Getter for base texts
  static Map<String, String> get baseTexts => _baseTexts;
  
  // Check if a key has a manual translation for the current language
  bool hasManualTranslation(String key) {
    if (_currentLanguage == 'en') return true;
    return _translationCache[_currentLanguage]?.containsKey(key) == true;
  }
  
  // Translate dynamic text (like event names, descriptions) using API
  Future<String> translateDynamicText(String text) async {
    if (_currentLanguage == 'en' || text.isEmpty) {
      return text;
    }
    
    // Check if we have this text cached
    final cacheKey = 'dynamic_$text';
    if (_translationCache[_currentLanguage]?.containsKey(cacheKey) == true) {
      return _translationCache[_currentLanguage]![cacheKey]!;
    }
    
    // Check if translation is already in progress
    if (_pendingTranslations.containsKey(cacheKey)) {
      debugPrint('⏳ Waiting for pending translation: "$text"');
      return await _pendingTranslations[cacheKey]!;
    }
    
    // Start new translation
    final translationFuture = _translateWithApi(text, _currentLanguage);
    _pendingTranslations[cacheKey] = translationFuture;
    
    try {
      final result = await translationFuture;
      _pendingTranslations.remove(cacheKey);
      return result;
    } catch (e) {
      _pendingTranslations.remove(cacheKey);
      debugPrint('❌ translateDynamicText failed: $e');
      return text;
    }
  }
  
  // Test API connectivity
  Future<bool> testApiConnectivity() async {
    try {
      debugPrint('Testing API connectivity...');
      final result = await _translateWithApi('Hello', 'mr');
      final isWorking = result != 'Hello'; // If translation worked, result should be different
      debugPrint('API test result: $result (working: $isWorking)');
      return isWorking;
    } catch (e) {
      debugPrint('API test failed: $e');
      return false;
    }
  }
  
  // Get debug info
  Map<String, dynamic> getDebugInfo() {
    return {
      'currentLanguage': _currentLanguage,
      'isInitialized': _isInitialized,
      'isApiEnabled': _apiEnabled,
      'apiFailureCount': _apiFailureCount,
      'lastApiFailure': _lastApiFailure?.toString() ?? 'None',
      'cacheKeys': _translationCache[_currentLanguage]?.keys.toList() ?? [],
      'cacheSize': _translationCache[_currentLanguage]?.length ?? 0,
    };
  }
  
  // Reset API completely
  void resetApi() {
    _apiEnabled = true;
    _apiFailureCount = 0;
    _lastApiFailure = null;
    debugPrint('Translation API completely reset');
    notifyListeners();
  }
}
