// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String title;
  final String communityName;
  final String communityProfilePic;
  final String userName;
  final String userUid;
  final String type;

  final String? link;
  final String? description;

  final int commentCount;
  final DateTime createdAt;

  final List<String> upVote;
  final List<String> downVote;
  final List<String> awards;
  Post({
    required this.id,
    required this.title,
    required this.communityName,
    required this.communityProfilePic,
    required this.userName,
    required this.userUid,
    required this.type,
    this.link,
    this.description,
    required this.commentCount,
    required this.createdAt,
    required this.upVote,
    required this.downVote,
    required this.awards,
  });

  Post copyWith({
    String? id,
    String? title,
    String? communityName,
    String? communityProfilePic,
    String? userName,
    String? userUid,
    String? type,
    String? link,
    String? description,
    int? commentCount,
    DateTime? createdAt,
    List<String>? upVote,
    List<String>? downVote,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      userName: userName ?? this.userName,
      userUid: userUid ?? this.userUid,
      type: type ?? this.type,
      link: link ?? this.link,
      description: description ?? this.description,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      upVote: upVote ?? this.upVote,
      downVote: downVote ?? this.downVote,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'communityName': communityName,
      'communityProfilePic': communityProfilePic,
      'userName': userName,
      'userUid': userUid,
      'type': type,
      'link': link,
      'description': description,
      'commentCount': commentCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'upVote': upVote,
      'downVote': downVote,
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
        id: map['id'] as String,
        title: map['title'] as String,
        communityName: map['communityName'] as String,
        communityProfilePic: map['communityProfilePic'] as String,
        userName: map['userName'] as String,
        userUid: map['userUid'] as String,
        type: map['type'] as String,
        link: map['link'] != null ? map['link'] as String : null,
        description: map['description'] != null ? map['description'] as String : null,
        commentCount: map['commentCount'] as int,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        upVote: List<String>.from((map['upVote'])),
        downVote: List<String>.from((map['downVote'])),
        awards: List<String>.from(
          (map['awards']),
        ));
  }
  @override
  String toString() {
    return 'Post(id: $id, title: $title, communityName: $communityName, communityProfilePic: $communityProfilePic, userName: $userName, userUid: $userUid, type: $type, link: $link, description: $description, commentCount: $commentCount, createdAt: $createdAt, upVote: $upVote, downVote: $downVote, awards: $awards)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.communityName == communityName &&
        other.communityProfilePic == communityProfilePic &&
        other.userName == userName &&
        other.userUid == userUid &&
        other.type == type &&
        other.link == link &&
        other.description == description &&
        other.commentCount == commentCount &&
        other.createdAt == createdAt &&
        listEquals(other.upVote, upVote) &&
        listEquals(other.downVote, downVote) &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        communityName.hashCode ^
        communityProfilePic.hashCode ^
        userName.hashCode ^
        userUid.hashCode ^
        type.hashCode ^
        link.hashCode ^
        description.hashCode ^
        commentCount.hashCode ^
        createdAt.hashCode ^
        upVote.hashCode ^
        downVote.hashCode ^
        awards.hashCode;
  }
}
