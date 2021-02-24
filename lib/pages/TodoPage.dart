/*
 * Copyright (c) 2021. Francesco D'anetra (@devdanetra | devdanetra@outlook.com)
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_test_for_apey/Models/TodoItem.dart';
import 'package:todo_test_for_apey/controllers/AuthController.dart';
import 'package:todo_test_for_apey/controllers/ListController.dart';

class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListController _listController = ListController();
    Get.put(_listController);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          SafeArea(
            child: Header(),
            top: true,
          ),
          TodoList(),
          IconButton(
              icon: Icon(Icons.add),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                TextEditingController _textController =
                    new TextEditingController();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Crea un nuovo to-to'),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              _listController.createTodo(_textController.text);
                              Get.back();
                            },
                            child: Text("Crea"),
                          )
                        ],
                        content: TextField(
                          controller: _textController,
                          decoration: InputDecoration(hintText: "Nuovo to-do"),
                        ),
                      );
                    });
              }),
          SizedBox(
            height: 50,
          ),
        ]));
  }
}

class Header extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 60,
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  child: Text(
                    "Todo List",
                    style: GoogleFonts.montserrat(
                        fontSize: 24, color: Colors.white),
                  ),
                  margin: EdgeInsets.only(left: 20))),
          Container(
              height: 30,
              width: 100,
              margin: EdgeInsets.only(right: 30),
              child: Container(
                  child: MaterialButton(
                onPressed: () {
                  controller.signOut();
                },
                color: Colors.white,
                child: Center(
                  child: Text("Logout"),
                ),
              ))),
        ],
      ),
      decoration:
          BoxDecoration(color: Theme.of(context).primaryColor, boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1),
            spreadRadius: 1.0,
            blurRadius: 2.0)
      ]),
    );
  }
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListController _listController = Get.find();
    return Obx(() {
      return _listController.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Expanded(
              child: ListView.builder(
                  controller: new ScrollController(),
                  itemCount: _listController.items.length,
                  itemBuilder: (context, index) {
                    print(_listController.items[index].toString());
                    return TodoTile(_listController.items[index]);
                  }));
    });
  }
}

class TodoTile extends StatelessWidget {
  final TodoItem _item;
  final ListController _listController = Get.find();

  TodoTile(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: 100,
      height: 50,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  child: Text(
                    "${_item.title}",
                    style: GoogleFonts.montserrat(
                        fontSize: 24, color: Colors.white),
                  ),
                  margin: EdgeInsets.only(left: 20))),
          Checkbox(value: _item.completed, onChanged: (value){
            _item.setCompleted(value);
            _listController.updateTodo(_item);
          }),
          IconButton(
            icon: Icon(Icons.cancel,color: Colors.white,),
            onPressed: () {
              _listController.deleteTodo(_item.uid);
            },
          ),
        ],
      ),
    );
  }
}
