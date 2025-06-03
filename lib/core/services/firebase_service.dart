import 'package:firebase_database/firebase_database.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FirebaseService {
  static const String _defaultMode = 'review';
  static const String _defaultUrl = '';

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  late final DatabaseReference _ref;

  // Кэш для версии приложения
  String? _appVersion;

  FirebaseService() {
    _ref = _database.ref();
  }

  // Получение версии приложения с кэшированием
  Future<String> _getAppVersion() async {
    if (_appVersion != null) return _appVersion!;

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String majorVersion = version.split('.')[0];
      _appVersion = 'v$majorVersion';
      print('App version detected: $_appVersion');
      return _appVersion!;
    } catch (e) {
      print('Error getting app version: $e, using default v1');
      _appVersion = 'v1';
      return _appVersion!;
    }
  }

  // Получение ссылки на версию
  Future<DatabaseReference> _getVersionRef() async {
    String version = await _getAppVersion();
    return _ref.child(version);
  }

  // VERSION-BASED STREAMS

  // Streams для реактивного обновления по версии
  Stream<String> getModeStream() async* {
    String version = await _getAppVersion();
    yield* _ref.child(version).child('mode').onValue
        .map((event) => event.snapshot.value as String? ?? _defaultMode)
        .handleError((error) {
      print('Error in getModeStream for $version: $error');
      return _defaultMode;
    });
  }

  Stream<String> getProductionUrlStream() async* {
    String version = await _getAppVersion();
    yield* _ref.child(version).child('url').onValue
        .map((event) => event.snapshot.value as String? ?? _defaultUrl)
        .handleError((error) {
      print('Error in getProductionUrlStream for $version: $error');
      return _defaultUrl;
    });
  }

  // Комбинированный поток для получения всех настроек версии
  Stream<Map<String, String>> getConfigStream() async* {
    String version = await _getAppVersion();
    yield* _ref.child(version).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      return {
        'mode': data?['mode'] as String? ?? _defaultMode,
        'url': data?['url'] as String? ?? _defaultUrl,
      };
    }).handleError((error) {
      print('Error in getConfigStream for $version: $error');
      return {
        'mode': _defaultMode,
        'url': _defaultUrl,
      };
    });
  }

  // VERSION-BASED ASYNC METHODS

  // Асинхронные методы для одноразового получения по версии
  Future<String> getMode() async {
    try {
      DatabaseReference versionRef = await _getVersionRef();
      final snapshot = await versionRef.child('mode').get();
      final value = snapshot.value as String? ?? _defaultMode;
      print('Firebase mode value for ${await _getAppVersion()}: $value');
      return value;
    } catch (e) {
      print('Error getting mode: $e');
      return _defaultMode;
    }
  }

  Future<String> getProductionUrl() async {
    try {
      DatabaseReference versionRef = await _getVersionRef();
      final snapshot = await versionRef.child('url').get();
      final value = snapshot.value as String? ?? _defaultUrl;
      print('Firebase url value for ${await _getAppVersion()}: $value');
      return value;
    } catch (e) {
      print('Error getting production URL: $e');
      return _defaultUrl;
    }
  }

  Future<Map<String, String>> getConfig() async {
    try {
      DatabaseReference versionRef = await _getVersionRef();
      final snapshot = await versionRef.get();
      final data = snapshot.value as Map<dynamic, dynamic>?;

      final config = {
        'mode': data?['mode'] as String? ?? _defaultMode,
        'url': data?['url'] as String? ?? _defaultUrl,
      };

      print('Firebase config for ${await _getAppVersion()}: $config');
      return config;
    } catch (e) {
      print('Error getting config: $e');
      return {
        'mode': _defaultMode,
        'url': _defaultUrl,
      };
    }
  }

  // SPECIFIC VERSION METHODS

  // Методы для работы с конкретной версией (для админки)
  Future<String> getModeForVersion(String version) async {
    try {
      final snapshot = await _ref.child(version).child('mode').get();
      final value = snapshot.value as String? ?? _defaultMode;
      print('Firebase mode value for $version: $value');
      return value;
    } catch (e) {
      print('Error getting mode for $version: $e');
      return _defaultMode;
    }
  }

  Future<String> getUrlForVersion(String version) async {
    try {
      final snapshot = await _ref.child(version).child('url').get();
      final value = snapshot.value as String? ?? _defaultUrl;
      print('Firebase url value for $version: $value');
      return value;
    } catch (e) {
      print('Error getting url for $version: $e');
      return _defaultUrl;
    }
  }

  Future<Map<String, String>> getConfigForVersion(String version) async {
    try {
      final snapshot = await _ref.child(version).get();
      final data = snapshot.value as Map<dynamic, dynamic>?;

      final config = {
        'mode': data?['mode'] as String? ?? _defaultMode,
        'url': data?['url'] as String? ?? _defaultUrl,
      };

      print('Firebase config for $version: $config');
      return config;
    } catch (e) {
      print('Error getting config for $version: $e');
      return {
        'mode': _defaultMode,
        'url': _defaultUrl,
      };
    }
  }

  // Получить все доступные версии
  Future<List<String>> getAvailableVersions() async {
    try {
      final snapshot = await _ref.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return data.keys
            .where((key) => key.toString().startsWith('v'))
            .map((key) => key.toString())
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting available versions: $e');
      return [];
    }
  }

  // WRITE METHODS

  // Методы для записи в текущую версию
  Future<bool> setMode(String mode) async {
    try {
      DatabaseReference versionRef = await _getVersionRef();
      await versionRef.child('mode').set(mode);
      print('Mode set to: $mode for ${await _getAppVersion()}');
      return true;
    } catch (e) {
      print('Error setting mode: $e');
      return false;
    }
  }

  Future<bool> setProductionUrl(String url) async {
    try {
      DatabaseReference versionRef = await _getVersionRef();
      await versionRef.child('url').set(url);
      print('Production URL set to: $url for ${await _getAppVersion()}');
      return true;
    } catch (e) {
      print('Error setting production URL: $e');
      return false;
    }
  }

  Future<bool> setConfig({String? mode, String? productionUrl}) async {
    try {
      DatabaseReference versionRef = await _getVersionRef();
      final updates = <String, dynamic>{};

      if (mode != null) updates['mode'] = mode;
      if (productionUrl != null) updates['url'] = productionUrl;

      await versionRef.update(updates);
      print('Config updated for ${await _getAppVersion()}: $updates');
      return true;
    } catch (e) {
      print('Error updating config: $e');
      return false;
    }
  }

  // Методы для записи в конкретную версию
  Future<bool> setModeForVersion(String version, String mode) async {
    try {
      await _ref.child(version).child('mode').set(mode);
      print('Mode set to: $mode for $version');
      return true;
    } catch (e) {
      print('Error setting mode for $version: $e');
      return false;
    }
  }

  Future<bool> setUrlForVersion(String version, String url) async {
    try {
      await _ref.child(version).child('url').set(url);
      print('URL set to: $url for $version');
      return true;
    } catch (e) {
      print('Error setting URL for $version: $e');
      return false;
    }
  }

  Future<bool> setConfigForVersion(String version, {String? mode, String? url}) async {
    try {
      final updates = <String, dynamic>{};

      if (mode != null) updates['mode'] = mode;
      if (url != null) updates['url'] = url;

      await _ref.child(version).update(updates);
      print('Config updated for $version: $updates');
      return true;
    } catch (e) {
      print('Error updating config for $version: $e');
      return false;
    }
  }

  // UTILITY METHODS

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

  // Получить текущую версию приложения
  Future<String> getCurrentAppVersion() async {
    return await _getAppVersion();
  }

  // Сброс кэша версии (полезно для тестирования)
  void resetVersionCache() {
    _appVersion = null;
  }

  // Создать структуру для новой версии
  Future<bool> initializeVersion(String version, {String? mode, String? url}) async {
    try {
      final config = {
        'mode': mode ?? _defaultMode,
        'url': url ?? _defaultUrl,
      };

      await _ref.child(version).set(config);
      print('Initialized version $version with config: $config');
      return true;
    } catch (e) {
      print('Error initializing version $version: $e');
      return false;
    }
  }

  // Копировать конфигурацию между версиями
  Future<bool> copyConfigBetweenVersions(String fromVersion, String toVersion) async {
    try {
      final config = await getConfigForVersion(fromVersion);
      await setConfigForVersion(toVersion,
          mode: config['mode'],
          url: config['url']);
      print('Copied config from $fromVersion to $toVersion');
      return true;
    } catch (e) {
      print('Error copying config from $fromVersion to $toVersion: $e');
      return false;
    }
  }

  // Отписка от всех слушателей (для очистки ресурсов)
  void dispose() {
    // Streams автоматически закроются при dispose BLoC
    _appVersion = null;
  }
}