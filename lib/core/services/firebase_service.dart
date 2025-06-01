import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static const String _defaultMode = 'review';
  static const String _defaultUrl = '';

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  late final DatabaseReference _ref;

  FirebaseService() {
    _ref = _database.ref();
  }

  // Streams для реактивного обновления
  Stream<String> getModeStream() {
    return _ref.child('mode').onValue
        .map((event) => event.snapshot.value as String? ?? _defaultMode)
        .handleError((error) {
      print('Error in getModeStream: $error');
      return _defaultMode;
    });
  }

  Stream<String> getProductionUrlStream() {
    return _ref.child('production_url').onValue
        .map((event) => event.snapshot.value as String? ?? _defaultUrl)
        .handleError((error) {
      print('Error in getProductionUrlStream: $error');
      return _defaultUrl;
    });
  }

  // Комбинированный поток для получения всех настроек сразу
  Stream<Map<String, String>> getConfigStream() {
    return _ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      return {
        'mode': data?['mode'] as String? ?? _defaultMode,
        'production_url': data?['production_url'] as String? ?? _defaultUrl,
      };
    }).handleError((error) {
      print('Error in getConfigStream: $error');
      return {
        'mode': _defaultMode,
        'production_url': _defaultUrl,
      };
    });
  }

  // Асинхронные методы для одноразового получения
  Future<String> getMode() async {
    try {
      final snapshot = await _ref.child('mode').get();
      final value = snapshot.value as String? ?? _defaultMode;
      print('Firebase mode value: $value');
      return value;
    } catch (e) {
      print('Error getting mode: $e');
      return _defaultMode;
    }
  }

  Future<String> getProductionUrl() async {
    try {
      final snapshot = await _ref.child('production_url').get();
      final value = snapshot.value as String? ?? _defaultUrl;
      print('Firebase production_url value: $value');
      return value;
    } catch (e) {
      print('Error getting production URL: $e');
      return _defaultUrl;
    }
  }

  Future<Map<String, String>> getConfig() async {
    try {
      final snapshot = await _ref.get();
      final data = snapshot.value as Map<dynamic, dynamic>?;

      final config = {
        'mode': data?['mode'] as String? ?? _defaultMode,
        'production_url': data?['production_url'] as String? ?? _defaultUrl,
      };

      print('Firebase config: $config');
      return config;
    } catch (e) {
      print('Error getting config: $e');
      return {
        'mode': _defaultMode,
        'production_url': _defaultUrl,
      };
    }
  }

  // Методы для записи
  Future<bool> setMode(String mode) async {
    try {
      await _ref.child('mode').set(mode);
      print('Mode set to: $mode');
      return true;
    } catch (e) {
      print('Error setting mode: $e');
      return false;
    }
  }

  Future<bool> setProductionUrl(String url) async {
    try {
      await _ref.child('production_url').set(url);
      print('Production URL set to: $url');
      return true;
    } catch (e) {
      print('Error setting production URL: $e');
      return false;
    }
  }

  Future<bool> setConfig({String? mode, String? productionUrl}) async {
    try {
      final updates = <String, dynamic>{};

      if (mode != null) updates['mode'] = mode;
      if (productionUrl != null) updates['production_url'] = productionUrl;

      await _ref.update(updates);
      print('Config updated: $updates');
      return true;
    } catch (e) {
      print('Error updating config: $e');
      return false;
    }
  }

  // Проверка подключения
  Future<bool> isConnected() async {
    try {
      final snapshot = await _ref.child('.info/connected').get();
      return snapshot.value as bool? ?? false;
    } catch (e) {
      print('Error checking connection: $e');
      return false;
    }
  }

  // Отписка от всех слушателей (для очистки ресурсов)
  void dispose() {
    // Streams автоматически закроются при dispose BLoC
  }
}