import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/features/chat/domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    required super.courseId,
    required super.members,
    super.groupImageUrl,
    super.lastMessage,
    super.lastMessageSenderName,
    super.lastMessageTimestamp,
  });

  GroupModel.empty()
      : this(
          id: '',
          name: '',
          courseId: '',
          members: [],
          groupImageUrl: '',
          lastMessage: '',
          lastMessageSenderName: '',
          lastMessageTimestamp: '',
        );

  GroupModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          courseId: map['courseId'] as String,
          members: (map['courseId'] as List<dynamic>).cast<String>(),
          groupImageUrl: map['groupImageUrl'] as String,
          lastMessage: map['lastMessage'] as String,
          lastMessageSenderName: map['lastMessageSenderName'] as String,
          lastMessageTimestamp: map['lastMessageTimestamp'] as String,
        );

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'courseId': courseId,
      'members': members,
      'groupImageUrl': groupImageUrl,
      'lastMessage': lastMessage,
      'lastMessageSenderName': lastMessageSenderName,
      'lastMessageTimestamp':
          lastMessageTimestamp == null ? null : FieldValue.serverTimestamp(),
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? courseId,
    List<String>? members,
    String? groupImageUrl,
    String? lastMessage,
    String? lastMessageSenderName,
    String? lastMessageTimestamp,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      courseId: courseId ?? this.courseId,
      members: members ?? this.members,
      groupImageUrl: groupImageUrl ?? this.groupImageUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderName:
          lastMessageSenderName ?? this.lastMessageSenderName,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
    );
  }
}
