import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/utils/typedefs.dart';

abstract interface class CourseRepo {
  const CourseRepo();

  ResultFuture<List<Course>> getCourses();

  ResultFuture<void> addCourse(Course course);

  // ResultFuture<void> updateCourse();
}
