import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/courses/data/datasources/course_remote_datasource.dart';
import 'package:education_app/core/common/features/courses/data/models/course_model.dart';
import 'package:education_app/core/common/features/courses/data/repositories/course_repository_impl.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/errors/exceptions.dart';
import 'package:education_app/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDatasource {}

void main() {
  late CourseRemoteDatasource remoteDatasource;
  late CourseRepositoryImpl courseRepositoryImpl;

  final tCourse = CourseModel.empty();

  setUp(() {
    remoteDatasource = MockCourseRemoteDataSource();
    courseRepositoryImpl = CourseRepositoryImpl(remoteDatasource);
    registerFallbackValue(tCourse);
  });

  const tException =
      ServerException(message: 'Something wrong', statusCode: 500);

  group('addCourse', () {
    test(
        'should complete successfully when call '
        '[CourseRepositoryImpl.addCourse] is successfull', () async {
      when(() => remoteDatasource.addCourse(any()))
          .thenAnswer((_) async => Future.value());

      final result = await courseRepositoryImpl.addCourse(tCourse);

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => remoteDatasource.addCourse(tCourse)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });

    test(
        'should return ServerException when call '
        '[CourseRepositoryImpl.addCourse] is fail', () async {
      when(() => remoteDatasource.addCourse(any())).thenThrow(
        ServerException(
          message: tException.message,
          statusCode: tException.statusCode,
        ),
      );

      final result = await courseRepositoryImpl.addCourse(tCourse);

      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(() => remoteDatasource.addCourse(tCourse)).called(1);

      verifyNoMoreInteractions(remoteDatasource);
    });
  });

  group('getCourses', () {
    test(
      'should complete successfully when call '
      '[CourseRepositoryImpl.getCourses] is successfull',
      () async {
        when(() => remoteDatasource.getCourses()).thenAnswer(
          (_) async => [tCourse],
        );

        final result = await courseRepositoryImpl.getCourses();

        expect(result, isA<Right<dynamic, List<Course>>>());

        verify(() => remoteDatasource.getCourses());
        verifyNoMoreInteractions(remoteDatasource);
      },
    );

    test(
      'should throw an exception when call '
      '[CourseRepositoryImpl.getCourses] is fail',
      () async {
        when(() => remoteDatasource.getCourses()).thenThrow(
          ServerException(
            message: tException.message,
            statusCode: tException.statusCode,
          ),
        );

        final result = await courseRepositoryImpl.getCourses();

        expect(
          result,
          Left<Failure, dynamic>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        );

        verify(() => remoteDatasource.getCourses());
        verifyNoMoreInteractions(remoteDatasource);
      },
    );
  });
}
