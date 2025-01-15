import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/courses/data/datasources/course_remote_datasource.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/common/features/courses/domain/repositories/course_repo.dart';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/errors/exceptions.dart';
import 'package:education_app/errors/failure.dart';

class CourseRepositoryImpl implements CourseRepo {
  const CourseRepositoryImpl(this._courseRemoteDatasource);

  final CourseRemoteDatasource _courseRemoteDatasource;

  @override
  ResultFuture<void> addCourse(Course course) async {
    try {
      await _courseRemoteDatasource.addCourse(course);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<List<Course>> getCourses() async {
    try {
      final result = await _courseRemoteDatasource.getCourses();
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        ServerFailure.fromException(e),
      );
    }
  }
}
