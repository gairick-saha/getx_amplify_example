import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/add_todo_controller.dart';

class AddTodoView extends GetView<AddTodoController> {
  const AddTodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Todo'),
        centerTitle: true,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification _notification) {
          _notification.disallowGlow();
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.1,
              ),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: ReactiveFormBuilder(
                  form: () => controller.todoForm,
                  builder:
                      (BuildContext context, FormGroup form, Widget? child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ReactiveTextField(
                          formControlName: 'name',
                          validationMessages: (FormControl<String?> control) =>
                              {
                            ValidationMessage.required: "Name can not be empty."
                          },
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        ReactiveTextField(
                          formControlName: 'description',
                          validationMessages: (FormControl<String?> control) =>
                              {
                            ValidationMessage.required:
                                "Description can not be empty."
                          },
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        Center(
                          child: Obx(
                            () => LoadingButton(
                              color: Theme.of(context).primaryColor,
                              type: controller.isTodoSubmiting.value
                                  ? LoadingButtonType.Outline
                                  : LoadingButtonType.Raised,
                              defaultWidget: const Text('SUBMIT'),
                              borderRadius: 15,
                              loadingWidget: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: controller.submitTodo,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
