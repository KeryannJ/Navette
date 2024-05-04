import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static String navetteAPIKey = 'NAVETTE';
  static String bearerKey = 'BEARER';
  static String userIdKey = 'USERID';

  static String navetteApi = '';
  static String bearer = '';
  static int userId = -1;

  static late SharedPreferences prefs;

  static getAllPref() {
    bearer = isNullString(prefs.getString(bearerKey));
    navetteApi = isNullString(prefs.getString(navetteAPIKey));
    userId = isNullInt(prefs.getInt(userIdKey), -1);
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

  static void setAPIValues(String navette, String bearer) {
    prefs.setString(navetteAPIKey, navette);
    prefs.setString(bearerKey, bearer);
  }

  static void setUserId(int uid) {
    prefs.setInt(userIdKey, uid);
  }
}
