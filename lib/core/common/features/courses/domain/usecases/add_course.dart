import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/common/features/courses/domain/repositories/course_repo.dart';
import 'package:education_app/core/common/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';

class AddCourse extends UsecaseWithParams<void, Course> {
  const AddCourse(this._courseRepo);

  final CourseRepo _courseRepo;

  @override
  ResultFuture<void> call(Course params) => _courseRepo.addCourse(params);
}
