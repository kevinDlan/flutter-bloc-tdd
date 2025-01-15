import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/common/features/courses/domain/usecases/add_course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_repo_mock.dart';

void main() {
  late CourseRepoMock courseRepoMock;
  late AddCourse usecase;

  final tCourse = Course.empty();

  setUp(() {
    courseRepoMock = CourseRepoMock();
    usecase = AddCourse(courseRepoMock);
    registerFallbackValue(tCourse);
  });

  test('should call [CousreRepo.addCourse]', () async {
    when(() => courseRepoMock.addCourse(any()))
        .thenAnswer((_) async => const Right(null));

    await usecase.call(tCourse);

    verify(() => courseRepoMock.addCourse(tCourse)).called(1);
    verifyNoMoreInteractions(courseRepoMock);
  });
}
