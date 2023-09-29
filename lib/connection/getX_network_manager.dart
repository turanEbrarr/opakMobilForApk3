import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GetXNetworkManager extends GetxController {
  int connectionType = 0;

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    GetConnectionType();
  }

  Future<void>GetConnectionType() async {
    var connectivityResult;
   //var connectivityResult = await (Connectivity().checkConnectivity());
if (connectivityResult == ConnectivityResult.none) {
  print("on internet connection");
} else {
   print ("internet var");
}
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      print(e);
    }
    return _updateState(connectivityResult);
  }

  _updateState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType = 1;
        update();
        break;

      case ConnectivityResult.mobile:
        connectionType = 2;
        update();
        break;

      case ConnectivityResult.none:
        connectionType = 0;
        update();
        break;

      default:
        Get.snackbar('Network Error', 'Failed to Network Status');
        break;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
