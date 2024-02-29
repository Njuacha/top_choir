
import 'dart:core';
import 'dart:math';

class MyEncryptionUtils {
  static String createGroupCode(String groupId) => '${getRandomString(4)}$groupId';

  static String getRandomString(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static String extractGroupIdFromCode(String groupCode) => groupCode.substring(4);

}