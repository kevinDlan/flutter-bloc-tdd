import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/features/auth/domain/entities/user.dart';

class UserModel extends LocalUser {
  const UserModel({
    required super.uid,
    required super.email,
    required super.point,
    required super.fullName,
    super.profilPic,
    super.bio,
    super.groupIds = const [],
    super.enrolledCourseIds = const [],
    super.following = const [],
    super.followers = const [],
  });

  const UserModel.empty()
      : this(
          uid: '',
          email: '',
          profilPic: '',
          bio: '',
          point: 0,
          fullName: '',
        );

  UserModel.fromMap(DataMap map)
      : super(
          uid: map['uid'] as String,
          email: map['email'] as String,
          profilPic: map['profilPic'] as String?,
          bio: map['bio'] as String?,
          point: (map['point'] as num).toInt(),
          fullName: map['fullName'] as String,
          groupIds: (map['groupIds'] as List<dynamic>).cast<String>(),
          enrolledCourseIds:
              (map['enrolledCourseIds'] as List<dynamic>).cast<String>(),
          following: (map['following'] as List<dynamic>).cast<String>(),
          followers: (map['followers'] as List<dynamic>).cast<String>(),
        );

  DataMap toMap() => {
        'uid': uid,
        'email': email,
        'profilPic': profilPic,
        'bio': bio,
        'point': point,
        'fullName': fullName,
        'groupIds': groupIds,
        'enrolledCourseIds': enrolledCourseIds,
        'following': following,
        'followers': followers,
      };

  UserModel copyWith({
    String? uid,
    String? email,
    String? profilPic,
    String? bio,
    int? point,
    String? fullName,
    List<String>? groupIds,
    List<String>? enrolledCourseIds,
    List<String>? following,
    List<String>? followers,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profilPic: profilPic ?? this.profilPic,
      bio: bio ?? this.bio,
      point: point ?? this.point,
      fullName: fullName ?? this.fullName,
      groupIds: groupIds ?? this.groupIds,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
}
