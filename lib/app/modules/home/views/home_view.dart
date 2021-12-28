import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_amplify/app/routes/app_pages.dart';
import 'package:getx_amplify/models/Todo.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // controller.fetchAllTodos();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        centerTitle: true,
      ),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _todoItem(
                    todo: controller.todoList[index],
                  );
                },
                childCount: controller.todoList.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_TODO),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _todoItem({required Todo todo}) {
    return ListTile(
      title: Text(
        todo.name,
      ),
      subtitle: todo.description == null
          ? null
          : Text(
              todo.description ?? '',
            ),
      leading: IconButton(
        onPressed: () => controller.toggleTodoSelection(todo),
        icon: todo.isComplete
            ? const Icon(Icons.check_box)
            : const Icon(Icons.check_box_outline_blank),
      ),
      trailing: IconButton(
        onPressed: () => controller.deleteTodo(todo),
        icon: const Icon(Icons.delete),
      ),
    );
  }
}
