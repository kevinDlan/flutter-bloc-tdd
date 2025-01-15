import 'package:equatable/equatable.dart';

class Group extends Equatable {
  const Group({
    required this.id,
    required this.name,
    required this.courseId,
    required this.members,
    this.lastMessage,
    this.groupImageUrl,
    this.lastMessageTimestamp,
    this.lastMessageSenderName,
  });

  // Group.empty()
  //     : this(
  //         id: 'id',
  //         name: 'name',
  //         courseId: 'courseId',
  //         members: [],
  //         lastMessage: 'lastMessage',
  //         groupImageUrl: 'groupImageUrl',
  //         lastMessageSenderName: 'lastMessageSenderName',
  //         lastMessageTimestamp: '567866776',
  //       );

  factory Group.empty() {
    return const Group(
      id: 'id',
      name: 'name',
      courseId: 'courseId',
      members: [],
    );
  }

  final String id;
  final String name;
  final String courseId;
  final List<String> members;
  final String? lastMessage;
  final String? groupImageUrl;
  final String? lastMessageTimestamp;
  final String? lastMessageSenderName;

  @override
  List<Object?> get props => [id, name, courseId];
}
