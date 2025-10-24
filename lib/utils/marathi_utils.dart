import '../services/translation_service.dart';
import 'translation_helper.dart';

class MarathiUtils {
  // Convert English numbers to Marathi (Devanagari)
  static String convertToMarathiNumber(dynamic number) {
    if (TranslationService().currentLanguage != 'mr') {
      return number.toString();
    }
    
    final englishToMarathi = {
      '0': '०',
      '1': '१',
      '2': '२',
      '3': '३',
      '4': '४',
      '5': '५',
      '6': '६',
      '7': '७',
      '8': '८',
      '9': '९',
    };
    
    String result = number.toString();
    englishToMarathi.forEach((eng, mar) {
      result = result.replaceAll(eng, mar);
    });
    
    return result;
  }
  
  // Format date in Marathi
  static String formatDate(String? dateStr) {
    if (dateStr == null) return "unknown_date".tr;
    
    try {
      final date = DateTime.parse(dateStr);
      final isMarathi = TranslationService().currentLanguage == 'mr';
      
      if (isMarathi) {
        final day = convertToMarathiNumber(date.day);
        final month = getMarathiMonth(date.month);
        final year = convertToMarathiNumber(date.year);
        return '$day $month $year';
      } else {
        return '${date.day} ${getEnglishMonth(date.month)} ${date.year}';
      }
    } catch (_) {
      return "unknown_date".tr;
    }
  }
  
  static String getMarathiMonth(int month) {
    const months = [
      'जानेवारी', 'फेब्रुवारी', 'मार्च', 'एप्रिल', 'मे', 'जून',
      'जुलै', 'ऑगस्ट', 'सप्टेंबर', 'ऑक्टोबर', 'नोव्हेंबर', 'डिसेंबर'
    ];
    return months[month - 1];
  }
  
  static String getEnglishMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

// Extension for easy access
extension MarathiNumberExtension on num {
  String get toMarathi => MarathiUtils.convertToMarathiNumber(this);
}
