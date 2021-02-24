/*
 * Copyright (c) 2021. Francesco D'anetra (@devdanetra | devdanetra@outlook.com)
 */
import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

part 'TodoItem.g.dart';

@JsonSerializable(nullable: true)
class TodoItem{
  String uid;
  String _title;
  bool _completed;
  DateTime _createdDate;
  DateTime _completedDate;


  TodoItem();

  TodoItem.fromTitle(String title){
    this._title = title;
    this._completed = false;
    this._createdDate = new DateTime.now();
    this._completedDate = null;
  }

  @override
  String toString() {
    return 'TodoItem{uid: $uid, _title: $_title, _completed: $_completed, _createdDate: $_createdDate, _completedDate: $_completedDate}';
  }

  String get title => _title;

  bool get completed => _completed;

  DateTime get createdDate => _createdDate;

  DateTime get completedDate => _completedDate;

  void setCompleted(bool completed){
    _completed = completed;
    if(_completed)
      _completedDate = DateTime.now();
    else
      _completedDate = null;
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) => _$TodoItemFromJson(json);
  Map<String, dynamic> toJson() => _$TodoItemToJson(this);

}