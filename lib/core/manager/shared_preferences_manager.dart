import 'package:shared_preferences/shared_preferences.dart';

enum PrefsType {
  isLoggedIn,
  userId,
  unReadNotificationCount,
  nickname,
}

extension on PrefsType {
  String get prefsName {
    return toString();
  }
}

class SharedPreferenceManager {
  SharedPreferenceManager._privateConstructor();

  static final SharedPreferenceManager _instance =
      SharedPreferenceManager._privateConstructor();

  factory SharedPreferenceManager() => _instance;

  late final SharedPreferences _prefs;

  SharedPreferences get prefs => _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  T? getPref<T>(PrefsType type) {
    switch (type) {
      case PrefsType.userId:
        return _prefs.getString(type.prefsName) as T?;
      case PrefsType.nickname:
        return _prefs.getString(type.prefsName) as T?;
      case PrefsType.unReadNotificationCount:
        return _prefs.getInt(type.prefsName) as T?;
      default:
        return _prefs.getBool(type.prefsName) as T?;
    }
  }

  Future<bool> setPref<T>(PrefsType type, T pref) async {
    switch (type) {
      case PrefsType.userId:
        return await _prefs.setString(type.prefsName, pref as String);
      case PrefsType.nickname:
        return await _prefs.setString(type.prefsName, pref as String);
      case PrefsType.unReadNotificationCount:
        return await _prefs.setInt(type.prefsName, pref as int);
      default:
        return await _prefs.setBool(type.prefsName, pref as bool);
    }
  }

  removePref(PrefsType type) async {
    await _prefs.remove(type.prefsName);
  }
}
