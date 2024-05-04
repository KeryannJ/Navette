import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static String navetteAPIKey = 'NAVETTE';
  static String mapsAPIKey = 'MAPS';
  static String bearerKey = 'BEARER';

  static String navetteApi = '';
  static String mapsApi = '';
  static String bearer = '';

  static late SharedPreferences prefs;

  static getAllPref() {
    bearer = isNullString(prefs.getString(bearerKey));
    navetteApi = isNullString(prefs.getString(navetteAPIKey));
    mapsApi = isNullString(prefs.getString(mapsAPIKey));
  }

  static void setPrefs(SharedPreferences tmpprefs) {
    prefs = tmpprefs;
    getAllPref();
  }

  static SharedPreferences getPrefs() {
    return prefs;
  }

  static bool isNullBool(bool? aBool) {
    if (aBool == null) {
      return false;
    } else {
      return aBool;
    }
  }

  static int isNullInt(int? aInt, int defaultValue) {
    if (aInt == null) {
      return defaultValue;
    } else {
      return aInt;
    }
  }

  static isNullString(String? aStr) {
    if (aStr == null) {
      return '';
    } else {
      return aStr;
    }
  }

  static void setBoolValue(String aStr, bool aBool) {
    saveKeyBool(aStr, aBool);
  }

  static void saveKeyBool(String aStr, bool aBool) {
    prefs.setBool(aStr, aBool);
  }

  static void setIntValue(String aStr, int aInt) {
    saveKeyInt(aStr, aInt);
  }

  static void saveKeyInt(String aStr, int aInt) {
    prefs.setInt(aStr, aInt);
  }

  static void setAPIValues(String navette, String maps, String bearer) {
    prefs.setString(navetteAPIKey, navette);
    prefs.setString(mapsAPIKey, maps);
    prefs.setString(bearerKey, bearer);
  }
}
