/*
 * Copyright (c) 2021. Francesco D'anetra (@devdanetra | devdanetra@outlook.com)
 */

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:todo_test_for_apey/Models/TodoItem.dart';

class ListController extends GetxController {
  final _databaseReference = FirebaseDatabase.instance.reference();
  String _userUID;
  RxBool _loading = false.obs;
  Rx<List<TodoItem>> _items = new Rx<List<TodoItem>>();
  StreamSubscription itemsStreamSubscription;

  List<TodoItem> get items => _items.value;
  get loading => _loading.value;


  @override
  void onClose() {
    itemsStreamSubscription.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    _userUID = FirebaseAuth.instance.currentUser.uid;
    _items.value = new List<TodoItem>();
    _loading.value = true;

    fetchInitialList();

    itemsStreamSubscription = _databaseReference.child("users/$_userUID/todos").orderByChild("createdDate").onValue.listen((event) { //fetching updates
      Map<dynamic, dynamic> map = event.snapshot.value;
      _items.value = new List<TodoItem>();
      if(map == null)
        return;
      map.forEach((key, value) {
        TodoItem todoItem = new TodoItem.fromJson(Map<String, dynamic>.from(value));
        todoItem.uid = key;
        _items.value.add(todoItem);
      });
    });

    _loading.value = false;
    super.onInit();
  }

  void fetchInitialList() async{
    DataSnapshot data = await _databaseReference.child("users/$_userUID/todos").orderByChild("createdDate").once();
    Map<dynamic, dynamic> map = data.value;
    if(map == null)
      return;
    map.forEach((key, value) {
      TodoItem todoItem = new TodoItem.fromJson(Map<String, dynamic>.from(value));
      todoItem.uid = key;
        _items.value.add(todoItem);
    });
    print("initial items");
    print(items);
  }

  void createTodo(String title){
      _databaseReference.child("users/$_userUID/todos/").push().set(TodoItem.fromTitle(title).toJson());
  }

  void updateTodo(TodoItem item){
    _databaseReference.child("users/$_userUID/todos/${item.uid}").update(item.toJson());
  }

  void deleteTodo(String uid){
    _databaseReference.child("users/$_userUID/todos/$uid").remove();
  }

}
