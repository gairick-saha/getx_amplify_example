import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:getx_amplify/amplifyconfiguration.dart';
import 'package:getx_amplify/models/ModelProvider.dart';

class AmplifyServices extends GetxService {
  static final ModelProvider _modelProvider = ModelProvider();

  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: _modelProvider);

  final AmplifyAPI _apiPlugin = AmplifyAPI();

  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();

  final AmplifyClass _amplify = Amplify;

  final RxBool isAmlifyConfigured = false.obs;

  Future<void> configureAmplify() async {
    try {
      // add Amplify plugins
      await _amplify.addPlugins([_dataStorePlugin, _apiPlugin, _authPlugin]);
      // configure Amplify
      // note that Amplify cannot be configured more than once!
      await _amplify.configure(amplifyconfig).then((_) {
        isAmlifyConfigured(true);
        debugPrint("Amplify Configured.");
      });
    } on AmplifyAlreadyConfiguredException {
      debugPrint(
          "Tried to reconfigure Amplify; this error occur when the app hot-reload");
    } catch (e) {
      // error handling can be improved for sure!
      // but this will be sufficient for the purposes of this tutorial
      debugPrint('An error occurred while configuring Amplify: $e');
    }
  }

  @override
  void onInit() {
    configureAmplify();
    super.onInit();
  }
}
