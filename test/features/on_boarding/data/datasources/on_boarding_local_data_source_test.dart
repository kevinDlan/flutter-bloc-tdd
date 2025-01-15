import 'package:education_app/errors/exceptions.dart';
import 'package:education_app/features/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences sharedPreferences;
  late OnBoardingLocalDataSourceImpl localDataSourceImpl;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    localDataSourceImpl = OnBoardingLocalDataSourceImpl(sharedPreferences);
  });

  group('CacheFirstTimer', () {
    test('should call [SharedPreferences] to cache the data', () async {
      when(() => sharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      await localDataSourceImpl.cacheFirstTimer();

      verify(() => sharedPreferences.setBool(kFirstTimerKey, false));
      verifyNoMoreInteractions(sharedPreferences);
    });

    test(
        'should throw a [CacheException] when there is an error '
        'catching the data', () async {
      when(() => sharedPreferences.setBool(any(), any()))
          .thenThrow(Exception());

      final methodCall = localDataSourceImpl.cacheFirstTimer;

      expect(methodCall, throwsA(isA<Exception>()));

      verify(() => sharedPreferences.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });
  });

  group('CheckIfUserIsFirstTimer', () {
    test(
        'should call [SharedPreferences] to check if user is first time and '
        'and return the right response from storage when data exists',
        () async {
      when(() => sharedPreferences.getBool(any())).thenReturn(false);

      final result = await localDataSourceImpl.checkIfUserIsFirstTimer();

      expect(result, false);

      verify(() => sharedPreferences.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });

    test('should return true if there is no data in storage', () async {
      when(() => sharedPreferences.getBool(any())).thenReturn(null);

      final result = await localDataSourceImpl.checkIfUserIsFirstTimer();

      expect(result, true);

      verify(() => sharedPreferences.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });

    test(
      'should throw a [CacheException] when there is an error '
      'retrieving data',
      () async {
        when(() => sharedPreferences.getBool(any())).thenThrow(Exception());

        final methodCall = localDataSourceImpl.checkIfUserIsFirstTimer;

        expect(methodCall, throwsA(isA<CacheException>()));
        verify(() => sharedPreferences.getBool(kFirstTimerKey)).called(1);
        verifyNoMoreInteractions(sharedPreferences);
      },
    );
  });
}
