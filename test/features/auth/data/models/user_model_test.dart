import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/features/auth/data/models/user_model.dart';
import 'package:education_app/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tUserModel = UserModel.empty();
  late DataMap tMap;
  setUp(() {
    tMap = jsonDecode(fixture('user.json')) as DataMap;
  });

  test('should be a subclass of [LocalUser] entity', () {
    // assert
    expect(tUserModel, isA<LocalUser>());
  });

  group('fromMap', () {
    test('should return a valid [UserModel] from a map', () {
      // act
      final result = UserModel.fromMap(tMap);
      // assert
      expect(result, isA<UserModel>());
      expect(result, equals(tUserModel));
    });

    test('should throw an error when the map is invalid', () {
      final map = tMap..remove('uid');

      const call = UserModel.fromMap;

      expect(() => call(map), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('should return a valid map from a [UserModel]', () {
      final result = tUserModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a valid [UserModel] with updated values', () {
      final result = tUserModel.copyWith(uid: '2');

      expect(result.uid, '2');
    });
  });
}
