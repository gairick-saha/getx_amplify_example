import 'dart:async';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:getx_amplify/models/Todo.dart';
import 'package:getx_amplify/services/amplify_services.dart';

class HomeController extends GetxController {
  final RxList<Todo> todoList = RxList<Todo>();

  late StreamSubscription<QuerySnapshot<Todo>> _todoSubscription;
  final AmplifyServices _amplifyServices = Get.find<AmplifyServices>();

  @override
  void onInit() {
    once(_amplifyServices.isAmlifyConfigured, (bool _amplifyConfigurede) {
      if (_amplifyConfigurede) {
        _fetchAllTodos();
      }
    });
    super.onInit();
  }

  void _fetchAllTodos() {
    _todoSubscription = Amplify.DataStore.observeQuery(Todo.classType)
        .listen((QuerySnapshot<Todo> snapshot) {
      todoList.clear();
      todoList(snapshot.items);
    });
  }

  Future<void> toggleTodoSelection(Todo todo) async {
    Todo updatedTodo = todo.copyWith(isComplete: !todo.isComplete);
    try {
      // to update data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(updatedTodo);
    } catch (e) {
      debugPrint('An error occurred while updating Todo: $e');
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    try {
      // to delete data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(todo);
    } catch (e) {
      debugPrint('An error occurred while deleting Todo: $e');
    }
  }

  @override
  void onClose() {
    _todoSubscription.cancel();
  }
}
