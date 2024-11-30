import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static String userIdKey = "USERKEY";
  static String forceNumberKey = "FORCENUMBERKEY";
  static String surnameKey = "SURNAMEKEY";
  static String rankKey = "RANKKEY";
  static String emailKey = "EMAILKEY";
  static String profPicUrlKey = "PROFPICURLKEY";
  static String situationKey = "SITUATIONKEY";
  static String isLoggedInKey = "ISLOGGEDIN";
  static String screenWidthKey = "SCREENWIDTHKEY";
  static String screenHeightKey = "SCREENHEIGHTKEY";

  //METHODS FOR SAVING DATA LOCALLY
  Future<bool> saveUserID(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveForceNumber(String getForceNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(forceNumberKey, getForceNumber);
  }

  Future<bool> saveSurname(String getSurname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(surnameKey, getSurname);
  }

  Future<bool> saveRank(String getRank) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(rankKey, getRank);
  }

  Future<bool> saveEmail(String getRank) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(emailKey, getRank);
  }

  Future<bool> saveProfPicUrl(String getProfPicUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(profPicUrlKey, getProfPicUrl);
  }

  Future<bool> saveSituation(String getSituation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(situationKey, getSituation);
  }

  Future<bool> saveIsloggedIn(bool getIsLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isLoggedInKey, getIsLoggedIn);
  }

  Future<bool> saveScreenWidth(double getScreenWidth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(screenWidthKey, getScreenWidth);
  }

  Future<bool> saveScreenHeight(double getScreenHeight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(screenHeightKey, getScreenHeight);
  }

  //METHODS FOR RETRIEVING DATA LOCALLY SAVED
  Future<String?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getForceNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(forceNumberKey);
  }

  Future<String?> getSurname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(surnameKey);
  }

  Future<String?> getRank() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(rankKey);
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  Future<String?> getProfPicUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(profPicUrlKey);
  }

  Future<String?> getSituation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(situationKey);
  }

  Future<double?> getScreenWidth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(screenWidthKey);
  }

  Future<double?> getScreenHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(screenHeightKey);
  }

  Future<bool?> getIsloggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? result = prefs.getBool(isLoggedInKey);
    if (result == null) {
      return false;
    } else {
      return result;
    }
  }
}
