
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RemoteConfig {

  static final RemoteConfig _instance = RemoteConfig._internal();

  // 내부 생성자
  RemoteConfig._internal();

  // 공용 팩토리 생성자
  factory RemoteConfig() {
    return _instance;
  }


  String _truncateVersion(String version) {
    RegExp regex = RegExp(r'^(\d+\.\d+)');
    Match? match = regex.firstMatch(version);
    if (match != null) {
      return match.group(1)!; // 첫 번째 그룹을 반환 (null 방지를 위해 non-null assertion 사용)
    } else {
      return version; // 정규 표현식과 매치되지 않는 경우, 원본 버전 반환
    }
  }

  FirebaseRemoteConfig _firebaseRemoteConfig = FirebaseRemoteConfig.instance;

  Future<void> remoteConfigFetchAndActivate() async {
    try {
      // 데이터 가져오기 시간 간격 : 12시간
      await _firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 12),
      ));

      await _firebaseRemoteConfig.fetchAndActivate();
      debugPrint('remoteConfigFetchAndActivate done');

    } catch (e) {
      debugPrint('remoteConfigFetchAndActivate e: $e');
    }
  }



  // 앱 버전 확인
  Future<bool> checkAppVersion() async {

    // await remoteConfigFetchAndActivate();

    // 앱 버전 정보 가져오기
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String appVersion = packageInfo.version ?? '';
    String buildNumber = packageInfo.buildNumber;

    debugPrint('appName :$appName');
    debugPrint('packageName :$packageName');
    debugPrint('appVersion :$appVersion');
    debugPrint('buildNumber :$buildNumber');

    // 파이어베이스 버전 정보 가져오기 remote config
    // (매개변수명 latest_version)

    String firebaseVersion = '';

    try {
      firebaseVersion = _firebaseRemoteConfig.getString("latest_version");
    } catch (e) {
      debugPrint('firebaseVersion e: $e');
    }

    debugPrint('firebaseVersion: $firebaseVersion');
    debugPrint('appVersion: $appVersion');

    double doubleFirebaseVersion = 1.0;
    double doubleAppVersion = 1.0;

    if (firebaseVersion != '' || appVersion != '') { // 앱 버전 또는 파이어베이스에서 앱 버전을 가져오는동안 문제가 없을때

      String truncatedFirebaseVersion = _truncateVersion(firebaseVersion) ?? '';
      String truncatedAppVersion = _truncateVersion(appVersion) ?? '';

      debugPrint('Truncated firebaseVersion: $truncatedFirebaseVersion'); // Truncated firebaseVersion: 1.0
      debugPrint('Truncated appVersion: $truncatedAppVersion'); // Truncated appVersion: 1.0

      doubleFirebaseVersion = double.parse(truncatedFirebaseVersion); // 1.0
      doubleAppVersion = double.parse(truncatedAppVersion); // 1.0

      debugPrint('if (firebaseVersion != '' || appVersion != '') doubleFirebaseVersion: $doubleFirebaseVersion');
      debugPrint('if (firebaseVersion != '' || appVersion != '') doubleAppVersion: $doubleAppVersion');

    } else { // 앱 버전 또는 파이어베이스에서 앱 버전을 가져오는동안 문제가 있는 경우,
      //doubleAppVersion == doubleFirebaseVersion 로 되게끔 별도의 설정을 안함
    }

    bool isUpdateNeeded = false;

    if (doubleAppVersion < doubleFirebaseVersion) { // 앱 업데이트 필요

      if (firebaseVersion == '') {
        isUpdateNeeded = false;
      } else { // 스토어에서 업데이트 필요
        isUpdateNeeded = true;
      }

    } else { // doubleAppVersion >= doubleFirebaseVersion
      // 앱 업데이트 불필요 (또는 심사를 거치는 경우)
      isUpdateNeeded = false;
    }

    debugPrint('firebaseVersion: $firebaseVersion');
    debugPrint('appVersion: $appVersion');
    debugPrint('isUpdateNeeded: $isUpdateNeeded');
    return isUpdateNeeded;

  }


}