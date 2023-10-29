import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorage {

  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }
  
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    switch(T) {
      case int:
        return prefs.getInt(key) as T?;
      
      case String:
        return prefs.getString(key) as T?;
      
      default:
        throw UnimplementedError('GET No implementado para el tipo ${T.runtimeType}');
    }

  }

  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  } 
  
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();
    switch(T) {
      case int:
        prefs.setInt(key, value as int);
        break;
      
      case String:
        prefs.setString(key, value as String);
        break;
      
      default:
        throw UnimplementedError('No implementado para el tipo ${T.runtimeType}');
    }
  }
} 