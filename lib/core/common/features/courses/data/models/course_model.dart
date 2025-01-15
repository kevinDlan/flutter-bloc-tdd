import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/utils/typedefs.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.numberOfExams,
    required super.numberOfVideos,
    required super.numberOfMaterials,
    required super.groupId,
    required super.createdAt,
    required super.updatedAt,
    super.image,
    super.description,
    super.imageIsFile,
  });

  CourseModel.empty()
      : this(
          id: 'empty.id',
          title: 'empty.title',
          description: 'empty.description',
          numberOfExams: 0,
          numberOfVideos: 0,
          numberOfMaterials: 0,
          groupId: 'empty.groupId',
          image: 'empty.image',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

  CourseModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          title: map['id'] as String,
          description: map['description'] as String?,
          numberOfExams: (map['numberOfExams'] as num).toInt(),
          numberOfVideos: (map['numberOfVideos'] as num).toInt(),
          numberOfMaterials: (map['numberOfMaterials'] as num).toInt(),
          groupId: map['groupId'] as String,
          image: map['image'] as String?,
          createdAt: (map['createdAt'] as Timestamp).toDate(),
          updatedAt: (map['createdAt'] as Timestamp).toDate(),
        );

  DataMap toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'numberOfExams': numberOfExams,
        'numberOfVideos': numberOfVideos,
        'numberOfMaterials': numberOfMaterials,
        'groupId': groupId,
        'image': image,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    int? numberOfExams,
    int? numberOfVideos,
    int? numberOfMaterials,
    String? groupId,
    String? image,
    bool? imageIsFile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      numberOfExams: numberOfExams ?? this.numberOfExams,
      numberOfVideos: numberOfVideos ?? this.numberOfVideos,
      numberOfMaterials: numberOfMaterials ?? this.numberOfMaterials,
      groupId: groupId ?? this.groupId,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
