import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_amplify/app/routes/app_pages.dart';
import 'package:getx_amplify/models/Todo.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: TodoSearch(),
              );
            },
            icon: const Icon(
              Icons.search_outlined,
            ),
          ),
        ],
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
}

Widget _todoItem({required Todo todo}) {
  return Center(
    child: ListTile(
      title: Text(
        todo.name,
      ),
      subtitle: todo.description == null
          ? null
          : Text(
              todo.description ?? '',
            ),
      leading: IconButton(
        onPressed: () => Get.find<HomeController>().toggleTodoSelection(todo),
        icon: todo.isComplete
            ? const Icon(Icons.check_box)
            : const Icon(Icons.check_box_outline_blank),
      ),
      trailing: IconButton(
        onPressed: () => Get.find<HomeController>().deleteTodo(todo),
        icon: const Icon(Icons.delete),
      ),
    ),
  );
}

class TodoSearch extends SearchDelegate {
  final HomeController _homeController = Get.find<HomeController>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final RxList<Todo> _suggestionsList = query.isEmpty
        ? _homeController.todoList
        : (_homeController.todoList
                    .where((element) => element.name.startsWith(query))
                    .isNotEmpty
                ? _homeController.todoList
                    .where((element) => element.name.startsWith(query))
                : _homeController.todoList.where(
                    (element) => (element.description ?? '').contains(query)))
            .toList()
            .obs;

    return Obx(
      () => ListView.separated(
        itemCount: _suggestionsList.length,
        separatorBuilder: (_, __) => const Divider(
          color: Colors.transparent,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _todoItem(todo: _suggestionsList[index]);
        },
      ),
    );
  }
}
