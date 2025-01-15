import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/common/features/courses/domain/usecases/get_course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_repo_mock.dart';

void main() {
  late CourseRepoMock courseRepoMock;
  late GetCourse usecase;

  setUp(() {
    courseRepoMock = CourseRepoMock();
    usecase = GetCourse(courseRepoMock);
  });

  test('should call [CourseRepo.getCourses]', () async {
    when(() => courseRepoMock.getCourses())
        .thenAnswer((_) async => const Right([]));

    final result = await usecase();

    expect(result, const Right<dynamic, List<Course>>([]));

    verify(() => courseRepoMock.getCourses()).called(1);

    verifyNoMoreInteractions(courseRepoMock);
  });
}
