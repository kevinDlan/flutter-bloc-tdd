import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/common/features/courses/domain/repositories/course_repo.dart';
import 'package:education_app/core/common/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';

class GetCourse extends UseCaseWithoutParams<List<Course>> {
  const GetCourse(this._courseRepo);

  final CourseRepo _courseRepo;

  @override
  ResultFuture<List<Course>> call() => _courseRepo.getCourses();
}
