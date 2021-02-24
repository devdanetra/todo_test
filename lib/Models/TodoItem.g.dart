// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TodoItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoItem _$TodoItemFromJson(Map<String, dynamic> json) {
  return TodoItem()
    ..uid = json['uid'] as String
    .._title = json['title'] as String
    .._completed = json['completed'] as bool
    .._createdDate = json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String)
    .._completedDate = json['completedDate'] == null
        ? null
        : DateTime.parse(json['completedDate'] as String);
}

Map<String, dynamic> _$TodoItemToJson(TodoItem instance) => <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'completed': instance.completed,
      'createdDate': instance.createdDate?.toIso8601String(),
      'completedDate': instance.completedDate?.toIso8601String(),
    };
