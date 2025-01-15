import 'package:equatable/equatable.dart';

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.numberOfExams,
    required this.numberOfVideos,
    required this.numberOfMaterials,
    required this.groupId,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    this.imageIsFile = false,
  });

  Course.empty()
      : this(
          id: 'empty.id',
          title: 'empty.title',
          description: 'empty description',
          numberOfExams: 0,
          numberOfVideos: 0,
          numberOfMaterials: 0,
          groupId: 'empty.groupId',
          image: 'empty.image',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

  final String id;
  final String title;
  final String? description;
  final int numberOfExams;
  final int numberOfVideos;
  final int numberOfMaterials;
  final String groupId;
  final String? image;
  final bool imageIsFile;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id];
}
