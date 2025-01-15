import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.point,
    required this.fullName,
    this.profilPic,
    this.bio,
    this.groupIds = const [],
    this.enrolledCourseIds = const [],
    this.following = const [],
    this.followers = const [],
  });

  const LocalUser.empty()
      : uid = '',
        email = '',
        profilPic = '',
        bio = '',
        point = 0,
        fullName = '',
        groupIds = const [],
        enrolledCourseIds = const [],
        following = const [],
        followers = const [];

  final String uid;
  final String email;
  final String? profilPic;
  final String? bio;
  final int point;
  final String fullName;
  final List<String> groupIds;
  final List<String> enrolledCourseIds;
  final List<String> following;
  final List<String> followers;

  @override
  List<Object?> get props => [email, uid];

  @override
  String toString() {
    return 'LocalUser(uid: $uid, email: $email, '
        'bio: $bio,point: $point, fullName: $fullName)';
  }
}
