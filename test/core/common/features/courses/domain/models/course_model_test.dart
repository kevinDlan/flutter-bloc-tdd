import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/courses/data/models/course_model.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../features/fixtures/fixture_reader.dart';

void main() {
  final timeStampData = {
    '_second': 1617483548,
    '_nanosecond': 123456000,
  };

  final date =
      DateTime.fromMillisecondsSinceEpoch(timeStampData['_second']!).add(
    Duration(
      microseconds: timeStampData['_nanosecond']!,
    ),
  );

  final timeStamp = Timestamp.fromDate(date);

  final tCourseModel = CourseModel.empty();
  late DataMap tMap;

  tMap = jsonDecode(fixture('course.json')) as DataMap;
  tMap['createdAt'] = timeStamp;
  tMap['updatedAt'] = timeStamp;

  test('should be a subclass of [Course] entity', () {
    expect(tCourseModel, isA<Course>());
  });

  group('empty', () {
    test('should return [courseModel] with empty data', () {
      final result = CourseModel.empty();

      expect(result.id, equals('empty.id'));
      expect(result.title, 'empty.title');
    });
  });

  group('fromMap', () {
    test('should return a valid CourseModel from map', () {
      final result = CourseModel.fromMap(tMap);

      // expect(result, isA<CourseModel>());
      expect(result, equals(tCourseModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] with a proper data', () async {
      final result = tCourseModel.toMap()
        ..remove('createdAt')
        ..remove('updatedAt');

      final newMap = Map<String, dynamic>.from(tMap)
        ..remove('createdAt')
        ..remove('updatedAt');

      expect(result, equals(newMap));
    });
  });

  group('copyWith', () {
    test('should return a [CourseModel] with a new data', () async {
      final result = tCourseModel.copyWith(title: 'new Title');

      expect(result.title, equals('new Title'));
    });
  });
}
