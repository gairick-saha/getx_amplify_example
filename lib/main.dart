import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_amplify/services/amplify_services.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(const _MyApp());
}

class _MyApp extends StatelessWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "GetX Amplify Example",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      initialBinding: BindingsBuilder(
        () {
          Get.put(AmplifyServices(), permanent: true);
        },
      ),
    );
  }
}
