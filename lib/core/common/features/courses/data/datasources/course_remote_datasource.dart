import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/courses/data/models/course_model.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/errors/exceptions.dart';
import 'package:education_app/features/chat/data/models/group_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract interface class CourseRemoteDatasource {
  const CourseRemoteDatasource();

  Future<List<CourseModel>> getCourses();

  Future<void> addCourse(Course course);
}

class CourseRemoteDatasourceImpl implements CourseRemoteDatasource {
  const CourseRemoteDatasourceImpl({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage firebaseStorage,
    required FirebaseAuth firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseStorage = firebaseStorage,
        _firebaseAuth = firebaseAuth;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> addCourse(Course course) async {
    try {
      final auth = _firebaseAuth.currentUser;
      if (auth == null) {
        throw const ServerException(
          message: 'user is not authenticate',
          statusCode: 401,
        );
      }

      final courseRef = _firebaseFirestore.collection('courses').doc();
      final groupRef = _firebaseFirestore.collection('groups').doc();

      var courseModel = (course as CourseModel).copyWith(
        id: courseRef.id,
        groupId: groupRef.id,
      );

      if (courseModel.imageIsFile) {
        final imageRef = _firebaseStorage.ref().child(
              'courses/${courseModel.id}/profile_image/${courseModel.title}-pfp',
            );
        await imageRef.putFile(File(courseModel.image!)).then((value) async {
          final url = await value.ref.getDownloadURL();
          courseModel = courseModel.copyWith(image: url);
        });
      }

      await courseRef.set(courseModel.toMap());

      final group = GroupModel(
        id: groupRef.id,
        name: course.title,
        courseId: courseRef.id,
        members: const [],
        groupImageUrl: courseModel.image,
      );

      return groupRef.set(group.toMap());
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknow error occured',
        statusCode: 500,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      final auth = _firebaseAuth.currentUser;
      if (auth == null) {
        throw const ServerException(
          message: 'user is not authenticate',
          statusCode: 401,
        );
      }

      return await _firebaseFirestore.collection('courses').get().then(
            (value) => value.docs
                .map((doc) => CourseModel.fromMap(doc.data()))
                .toList(),
          );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknow error occured',
        statusCode: 500,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
