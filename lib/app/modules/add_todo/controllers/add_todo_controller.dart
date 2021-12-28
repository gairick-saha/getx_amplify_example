import 'package:amplify_flutter/amplify.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:getx_amplify/models/ModelProvider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddTodoController extends GetxController {
  final RxBool isTodoSubmiting = false.obs;

  final FormGroup todoForm = FormGroup({
    "name": FormControl<String>(
      validators: [Validators.required],
    ),
    "description": FormControl<String>(
      validators: [Validators.required],
    ),
  });

  void submitTodo() async {
    if (todoForm.valid) {
      isTodoSubmiting(true);

      // print(todoForm.value);
      final Todo _newTodo = Todo(
        name: todoForm.control('name').value,
        isComplete: false,
        description: todoForm.control('description').value,
      );

      await _saveTodo(todo: _newTodo).then((bool _todoSubmitted) {
        if (_todoSubmitted) {
          Get.back();
          isTodoSubmiting(!_todoSubmitted);
        } else {
          BotToast.showText(text: 'Error saving todo.');
          isTodoSubmiting(false);
        }
      });
    } else {
      todoForm.markAllAsTouched();
    }
  }

  Future<bool> _saveTodo({required Todo todo}) async {
    return await Future.delayed(2000.milliseconds, () async {
      try {
        // to write data to DataStore, we simply pass an instance of a model to
        // Amplify.DataStore.save()
        return await Amplify.DataStore.save(todo).then((_) {
          return true;
        });
      } catch (e) {
        debugPrint('An error occurred while saving Todo: $e');
      }
      return false;
    });
  }
}
